module Model.Update exposing (withMessage)

import Auth.Start
import Debug
import Form exposing (Form)
import Forms.Types
import Forms.Utils exposing (..)
import GraphQL.Mutations
import GraphQL.Queries
import Http exposing (Error(..))
import Json.Decode as Json
import Model.Types exposing (..)
import Model.Utils
import Navigation exposing (modifyUrl, newUrl)
import Signals.Ports exposing (storeAuthToken)
import Utils


genericError : String
genericError =
    "Something went wrong."



-- Update


withMessage : Msg -> Model -> ( Model, Cmd Msg )
withMessage msg model =
    case msg of
        GoToMap mapName ->
            (!) model [ newUrl ("/maps/" ++ Model.Utils.encodeMapName mapName) ]

        SetPage page ->
            (!)
                { model | currentPage = page }
                [ case page of
                    Detail encodedMapName ->
                        encodedMapName
                            |> Model.Utils.decodeMapName
                            |> GraphQL.Queries.mapItems model

                    _ ->
                        Cmd.none
                ]

        -- Auth
        Authenticate token ->
            (!) { model | authenticatedWith = Just token } []

        Deauthenticate ->
            (!) { model | authenticatedWith = Nothing } []

        SetAuthEmail email ->
            (!) { model | authEmail = Just email } []

        -- Auth :: Start
        StartAuth ->
            (!)
                { model | isLoading = True }
                [ Auth.Start.doStart model ]

        HandleStartAuth (Ok _) ->
            (!)
                { model | isLoading = False }
                [ newUrl "/auth/start/success" ]

        HandleStartAuth (Err (BadPayload err _)) ->
            (!)
                { model | isLoading = False, errorState = err }
                [ newUrl "/auth/start/error" ]

        HandleStartAuth (Err _) ->
            (!)
                { model | isLoading = False, errorState = genericError }
                [ newUrl "/auth/start/error" ]

        -- Auth :: Exchange
        HandleExchangeAuth (Ok token) ->
            let
                newModel =
                    { model | authenticatedWith = Just token }
            in
                newModel
                    ! [ modifyUrl "/"
                      , storeAuthToken token
                      , GraphQL.Queries.maps newModel
                      ]

        HandleExchangeAuth (Err (BadPayload err _)) ->
            (!)
                { model | isLoading = False, errorState = err }
                [ newUrl "/auth/exchange/error" ]

        HandleExchangeAuth (Err _) ->
            (!)
                { model | isLoading = False, errorState = genericError }
                [ newUrl "/auth/exchange/error" ]

        -- Auth :: Validate
        HandleValidateAuth (Ok _) ->
            (!)
                model
                [ GraphQL.Queries.maps model ]

        HandleValidateAuth (Err (BadPayload err _)) ->
            (!)
                { model | isLoading = False, errorState = err }
                [ newUrl "/auth/validation/error" ]

        HandleValidateAuth (Err _) ->
            (!)
                { model | isLoading = False, errorState = genericError }
                [ newUrl "/auth/validation/error" ]

        -- Forms
        HandleCreateForm formMsg ->
            let
                newModel =
                    { model | createForm = Form.update formMsg model.createForm }
            in
                if canSubmitForm formMsg newModel.createForm then
                    (!)
                        { newModel | isLoading = True }
                        [ GraphQL.Mutations.create newModel ]
                else
                    (!)
                        { newModel | createServerError = Nothing }
                        []

        -- GraphQL :: Create map
        CreateMap (Ok value) ->
            let
                collection =
                    case decodeGraphQL value Model.Utils.keyMapDecoder of
                        Just m ->
                            model.collection ++ [ m ]

                        Nothing ->
                            model.collection
            in
                (!)
                    { model
                        | isLoading = False
                        , collection = collection
                        , createForm = resetForm model.createForm
                        , createServerError = Nothing
                    }
                    []

        CreateMap (Err (BadPayload err _)) ->
            (!) { model | isLoading = False, createServerError = Just err } []

        CreateMap (Err _) ->
            (!) { model | isLoading = False, createServerError = Just genericError } []

        -- GraphQL :: Load maps
        LoadMaps (Ok value) ->
            let
                maps =
                    Json.list Model.Utils.keyMapDecoder
                        |> decodeGraphQL value
                        |> Maybe.withDefault []
            in
                (!) { model | isLoading = False, collection = maps } []

        LoadMaps (Err _) ->
            -------
            -- TODO
            -------
            (!) { model | isLoading = False } []

        -- GraphQL :: Load map items
        LoadMapItems (Ok value) ->
            let
                items =
                    Json.list Model.Utils.keyItemDecoder
                        |> decodeGraphQL value
                        |> Maybe.withDefault []

                maybeMapId =
                    Maybe.map .map_id (List.head items)

                collection =
                    case maybeMapId of
                        Just mapId ->
                            List.map (storeItems mapId items) model.collection

                        Nothing ->
                            model.collection
            in
                (!) { model | isLoading = False, collection = collection } []

        LoadMapItems (Err _) ->
            (!) { model | isLoading = False } []



-- Helpers


decodeGraphQL : Json.Value -> Json.Decoder a -> Maybe a
decodeGraphQL value decoder =
    case Json.decodeValue decoder value of
        Ok decodedValue ->
            Just decodedValue

        Err err ->
            value
                |> Debug.log ("Could not parse json from GraphQL response (`" ++ err ++ "`)")
                |> \_ -> Nothing


storeItems : String -> List KeyItem -> KeyMap -> KeyMap
storeItems mapId items keyMap =
    if keyMap.id == mapId then
        { keyMap | items = Just items }
    else
        keyMap
