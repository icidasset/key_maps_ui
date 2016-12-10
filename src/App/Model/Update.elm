module Model.Update exposing (withMessage)

import Auth.Start
import Debug
import Form exposing (Form)
import Form.Field
import Form.Init
import Forms.Types
import Forms.Utils exposing (..)
import GraphQL.Mutations
import GraphQL.Queries
import Http exposing (Error(..))
import Json.Decode as Json
import Model.Types exposing (..)
import Model.Utils
import Navigation exposing (modifyUrl, newUrl)
import Signals.Ports as Ports
import Task
import Utils


genericError : String
genericError =
    "Something went wrong."



-- Update


withMessage : Msg -> Model -> ( Model, Cmd Msg )
withMessage msg model =
    case msg of
        ---------------------------------------
        -- Dialogs
        ---------------------------------------
        Confirm bool ->
            let
                confirmMsg =
                    case bool of
                        True ->
                            Maybe.map (\c -> c.ok) model.confirm

                        False ->
                            Nothing
            in
                (!)
                    { model | confirm = Nothing }
                    [ case confirmMsg of
                        Just theMsg ->
                            Task.perform identity (Task.succeed theMsg)

                        Nothing ->
                            Cmd.none
                    ]

        ConfirmToRemoveMap id ->
            (!)
                { model | confirm = Just { ok = ExecRemoveMap id } }
                [ Ports.askForConfirmation "Are you sure you want to remove this map?" ]

        ---------------------------------------
        -- Auth
        ---------------------------------------
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
                      , Ports.storeAuthToken token
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

        ---------------------------------------
        -- Forms
        ---------------------------------------
        HandleAddItemForm formMsg ->
            let
                newModel =
                    { model | addItemForm = Form.update formMsg model.addItemForm }
            in
                if canSubmitForm formMsg newModel.addItemForm then
                    (!)
                        { newModel | isLoading = True }
                        [{- TODO -}]
                else
                    (!)
                        { newModel | addItemServerError = Nothing }
                        []

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

        ---------------------------------------
        -- GraphQL
        ---------------------------------------
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
            (!) { model | isLoading = False } [ modifyUrl "/errors/map" ]

        -- GraphQL :: Load maps
        LoadMaps (Ok value) ->
            let
                maps =
                    Json.list Model.Utils.keyMapDecoder
                        |> decodeGraphQL value
                        |> Maybe.withDefault []

                newModel =
                    { model
                        | isLoading =
                            case model.currentPage of
                                Detail _ ->
                                    True

                                _ ->
                                    False
                        , collection = maps
                    }
            in
                (!)
                    newModel
                    [ -- Load map items of a specific map
                      case model.currentPage of
                        Detail encodeMapName ->
                            mapItemsCommand newModel encodeMapName

                        _ ->
                            Cmd.none
                    ]

        LoadMaps (Err _) ->
            (!) { model | isLoading = False } [ newUrl "/errors/maps" ]

        -- GraphQL :: Remove map
        ExecRemoveMap id ->
            (!)
                { model | collection = List.filter (\c -> c.id /= id) model.collection }
                [ GraphQL.Mutations.remove model id
                , modifyUrl "/"
                ]

        RemoveMap (Ok _) ->
            (!) model []

        RemoveMap (Err _) ->
            -- TODO
            (!) model []

        ---------------------------------------
        -- Navigation
        ---------------------------------------
        GoToIndex ->
            (!) model [ newUrl ("/") ]

        GoToMap mapName ->
            (!) model [ newUrl ("/maps/" ++ Model.Utils.encodeMapName mapName) ]

        -- Navigation :: PRIVATE
        SetPage (Detail encodedMapName) ->
            case model.authenticatedWith of
                Just _ ->
                    let
                        isLoading =
                            encodedMapName
                                |> Model.Utils.decodeMapName
                                |> Model.Utils.isEmptyKeyMap model.collection

                        page =
                            Detail encodedMapName
                    in
                        (!)
                            { model
                                | isLoading = isLoading
                                , addItemForm = setAddItemFormFields model encodedMapName
                                , currentPage = page
                            }
                            [ mapItemsCommand model encodedMapName ]

                Nothing ->
                    (!) { model | currentPage = Detail encodedMapName } []

        SetPage page ->
            (!) { model | currentPage = page } []



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


mapItemsCommand : Model -> String -> Cmd Msg
mapItemsCommand model encodedMapName =
    encodedMapName
        |> Model.Utils.decodeMapName
        |> GraphQL.Queries.mapItems model


setAddItemFormFields : Model -> String -> Form String Forms.Types.AddItemForm
setAddItemFormFields model encodedMapName =
    let
        keyMap =
            encodedMapName
                |> Model.Utils.decodeMapName
                |> Model.Utils.getMap model.collection
                |> Maybe.withDefault fakeKeyMap

        fields =
            List.map (\a -> Form.Init.setString a "") keyMap.attributes

        fields_ =
            [ Form.Init.setGroup "attributes" fields ]
    in
        Form.update (Form.Reset fields_) model.addItemForm


storeItems : String -> List KeyItem -> KeyMap -> KeyMap
storeItems mapId items keyMap =
    if keyMap.id == mapId then
        { keyMap | items = Just items }
    else
        keyMap
