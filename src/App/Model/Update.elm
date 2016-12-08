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
            (!) model [ newUrl ("/maps/" ++ mapName) ]

        SetPage page ->
            (!) { model | currentPage = page } []

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
                    case decodeGraphQL value keyMapDecoder of
                        Just m ->
                            model.keymaps ++ [ m ]

                        Nothing ->
                            model.keymaps
            in
                (!)
                    { model
                        | isLoading = False
                        , createForm = resetForm model.createForm
                        , createServerError = Nothing
                        , keymaps = collection
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
                    Json.list keyMapDecoder
                        |> decodeGraphQL value
                        |> Maybe.withDefault []
            in
                (!) { model | isLoading = False, keymaps = maps } []

        LoadMaps (Err _) ->
            -- TODO
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
