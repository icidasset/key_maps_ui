module Model.Update exposing (withMessage)

import Auth.Start
import Auth.Utils
import Debug
import Dict
import Form exposing (Form)
import Form.Field
import Form.Init
import Forms.Types
import Forms.Init exposing (..)
import Forms.Utils exposing (..)
import GraphQL.Mutations
import GraphQL.Queries
import GraphQL.Utils exposing (decodeGraphQL)
import Http exposing (Error(..))
import Json.Decode as Json
import Json.Encode
import List.Extra as List
import Model.Types exposing (..)
import Model.Utils exposing (mapUrl, storeItem, storeItems)
import Navigation exposing (modifyUrl, newUrl)
import Set
import Signals.Ports as Ports
import Task


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
        Deauthenticate ->
            (!) { model | authEmail = Nothing, authenticatedWith = Nothing, userId = Nothing } []

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
                    { model
                        | authenticatedWith = Just token
                        , isLoading = True
                        , userId = Auth.Utils.getUserIdFromToken token
                    }
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
        HandleCreateItemForm formMsg ->
            case
                submitForm
                    .createItemForm
                    (\m v -> { m | createItemForm = v })
                    (\m v -> { m | createItemServerError = v })
                    model
                    formMsg
            of
                ( m, True ) ->
                    (!) { m | isLoading = False } [ GraphQL.Mutations.createItem m ]

                ( m, False ) ->
                    (!) m []

        HandleCreateMapForm formMsg ->
            case
                submitForm
                    .createMapForm
                    (\m v -> { m | createMapForm = v })
                    (\m v -> { m | createMapServerError = v })
                    model
                    formMsg
            of
                ( m, True ) ->
                    (!) m [ GraphQL.Mutations.createMap m ]

                ( m, False ) ->
                    (!) m []

        HandleEditMapForm formMsg ->
            case
                submitForm
                    .editMapForm
                    (\m v -> { m | editMapForm = v })
                    (\m v -> { m | editMapServerError = v })
                    model
                    formMsg
            of
                ( m, True ) ->
                    (!) m [ GraphQL.Mutations.updateMap m ]

                ( m, False ) ->
                    (!) m []

        HandleSortItemsForm formMsg ->
            let
                newModel =
                    { model | sortItemsForm = Form.update formMsg model.sortItemsForm }
            in
                (!)
                    newModel
                    [ case formMsg of
                        Form.Input _ _ (Form.Field.String sortValue) ->
                            let
                                mapId =
                                    newModel.sortItemsForm
                                        |> Form.getFieldAsString "mapId"
                                        |> .value
                                        |> Maybe.withDefault "InvalidId"

                                keyMap =
                                    List.find (\m -> m.id == mapId) newModel.collection

                                settings =
                                    keyMap
                                        |> Maybe.map (\m -> m.settings)
                                        |> Maybe.map (\s -> Dict.insert "sortBy" sortValue s)
                            in
                                case settings of
                                    Just settings_ ->
                                        GraphQL.Mutations.updateMapSettings newModel settings_

                                    Nothing ->
                                        Cmd.none

                        _ ->
                            Cmd.none
                    ]

        ---------------------------------------
        -- GraphQL
        ---------------------------------------
        ExecRemoveMap id ->
            (!)
                { model | collection = List.filter (\c -> c.id /= id) model.collection }
                [ GraphQL.Mutations.removeMap model id
                , modifyUrl "/"
                ]

        -- GraphQL :: Create map
        CreateMap (Ok value) ->
            let
                keyMap =
                    decodeGraphQL value Model.Utils.keyMapDecoder

                collection =
                    case keyMap of
                        Just m ->
                            model.collection ++ [ m ]

                        Nothing ->
                            model.collection
            in
                (!)
                    { model
                        | isLoading = False
                        , collection = collection
                        , createMapForm = resetForm model.createMapForm
                        , createMapServerError = Nothing
                    }
                    [ case keyMap of
                        Just km ->
                            newUrl (mapUrl km.name)

                        Nothing ->
                            Cmd.none
                    ]

        CreateMap (Err (BadPayload err _)) ->
            (!) { model | isLoading = False, createMapServerError = Just err } []

        CreateMap (Err _) ->
            (!) { model | isLoading = False, createMapServerError = Just genericError } []

        -- GraphQL :: Create map item
        CreateMapItem (Ok value) ->
            let
                maybeItem =
                    decodeGraphQL value Model.Utils.keyItemDecoder

                collection =
                    case maybeItem of
                        Just item ->
                            List.map (storeItem item.map_id item) model.collection

                        Nothing ->
                            model.collection
            in
                (!)
                    { model | isLoading = False, collection = collection }
                    []

        CreateMapItem (Err (BadPayload err _)) ->
            (!) { model | isLoading = False, createItemServerError = Just err } []

        CreateMapItem (Err _) ->
            (!) { model | isLoading = False, createItemServerError = Just genericError } []

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

                loadedItemsFromMaps =
                    case maybeMapId of
                        Just mapId ->
                            Set.insert mapId model.loadedItemsFromMaps

                        Nothing ->
                            model.loadedItemsFromMaps
            in
                (!)
                    { model
                        | isLoading = False
                        , collection = collection
                        , loadedItemsFromMaps = loadedItemsFromMaps
                    }
                    []

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
                    { model | collection = maps }
            in
                withMessage (SetPage model.currentPage) newModel

        LoadMaps (Err _) ->
            (!) { model | isLoading = False } [ newUrl "/errors/maps" ]

        -- GraphQL :: Remove map
        RemoveMap (Ok _) ->
            {- Nothing needs to happen, silently remove -}
            (!) model []

        RemoveMap (Err _) ->
            {- TODO: Not sure what to do if the removal fails -}
            (!) model []

        -- GraphQL :: Update map
        UpdateMap (Ok value) ->
            let
                keyMap =
                    decodeGraphQL value Model.Utils.keyMapDecoder

                collection =
                    case keyMap of
                        Just m ->
                            List.map
                                (\c ->
                                    if c.id == m.id then
                                        { m | items = c.items }
                                    else
                                        c
                                )
                                model.collection

                        Nothing ->
                            model.collection
            in
                (!)
                    { model
                        | isLoading = False
                        , collection = collection
                        , editMapServerError = Nothing
                    }
                    [ case keyMap of
                        Just km ->
                            newUrl (mapUrl km.name ++ "/edit")

                        Nothing ->
                            Cmd.none
                    ]

        UpdateMap (Err (BadPayload err _)) ->
            (!) { model | isLoading = False, editMapServerError = Just err } []

        UpdateMap (Err _) ->
            (!) { model | isLoading = False, editMapServerError = Just genericError } []

        -- GraphQL :: Update map settings
        UpdateMapSettings (Ok value) ->
            let
                keyMap =
                    decodeGraphQL value Model.Utils.keyMapDecoder

                collection =
                    case keyMap of
                        Just m ->
                            List.map
                                (\c ->
                                    if c.id == m.id then
                                        { m | items = c.items }
                                    else
                                        c
                                )
                                model.collection

                        Nothing ->
                            model.collection
            in
                (!) { model | collection = collection } []

        UpdateMapSettings (Err _) ->
            {- TODO? -}
            (!) model []

        ---------------------------------------
        -- Navigation
        ---------------------------------------
        GoToEditMap mapName ->
            (!) model [ newUrl (mapUrl mapName ++ "/edit") ]

        GoToIndex ->
            (!) model [ newUrl ("/") ]

        GoToMap mapName ->
            (!) model [ newUrl (mapUrl mapName) ]

        -- Navigation :: PRIVATE
        SetPage (DetailMap encodedMapName) ->
            case model.authenticatedWith of
                Just _ ->
                    let
                        isLoading =
                            not (Model.Utils.haveMapItemsBeenLoaded model encodedMapName)
                    in
                        (!)
                            { model
                                | isLoading = isLoading
                                , createItemForm = setCreateItemFormFields model encodedMapName
                                , sortItemsForm = setSortItemsFormFields model encodedMapName
                                , currentPage = DetailMap encodedMapName
                            }
                            [ loadMapItems model encodedMapName ]

                Nothing ->
                    (!)
                        { model
                            | isLoading = False
                            , currentPage = DetailMap encodedMapName
                        }
                        []

        SetPage (EditMap encodedMapName) ->
            case model.authenticatedWith of
                Just _ ->
                    (!)
                        { model
                            | isLoading = False
                            , currentPage = EditMap encodedMapName
                            , editMapForm = setEditMapFormFields model encodedMapName
                        }
                        []

                Nothing ->
                    (!)
                        { model
                            | isLoading = False
                            , currentPage = EditMap encodedMapName
                        }
                        []

        SetPage page ->
            (!) { model | isLoading = False, currentPage = page } []



-- Helpers


loadMapItems : Model -> String -> Cmd Msg
loadMapItems model encodedMapName =
    encodedMapName
        |> Model.Utils.decodeMapName
        |> GraphQL.Queries.mapItems model
