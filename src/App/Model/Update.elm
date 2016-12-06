module Model.Update exposing (withMessage)

import Auth.Start
import GraphQL.Queries
import Http exposing (Error(..))
import Json.Decode
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
            model
                ! [ newUrl ("/maps/" ++ mapName) ]

        SetPage page ->
            { model | currentPage = page }
                ! []

        -- Auth
        Authenticate token ->
            { model | authenticatedWith = Just token }
                ! []

        Deauthenticate ->
            { model | authenticatedWith = Nothing }
                ! []

        SetAuthEmail email ->
            { model | authEmail = Just email }
                ! []

        -- Auth :: Start
        StartAuth ->
            { model | isLoading = True }
                ! [ Auth.Start.doStart model ]

        HandleStartAuth (Ok _) ->
            { model | isLoading = False }
                ! [ newUrl "/auth/start/success" ]

        HandleStartAuth (Err (BadPayload err _)) ->
            { model | isLoading = False, errorState = err }
                ! [ newUrl "/auth/start/error" ]

        HandleStartAuth (Err _) ->
            { model | isLoading = False, errorState = genericError }
                ! [ newUrl "/auth/start/error" ]

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
            { model | isLoading = False, errorState = err }
                ! [ newUrl "/auth/exchange/error" ]

        HandleExchangeAuth (Err _) ->
            { model | isLoading = False, errorState = genericError }
                ! [ newUrl "/auth/exchange/error" ]

        -- Auth :: Validate
        HandleValidateAuth (Ok _) ->
            model
                ! [ GraphQL.Queries.maps model ]

        HandleValidateAuth (Err (BadPayload err _)) ->
            { model | isLoading = False, errorState = err }
                ! [ newUrl "/auth/validation/error" ]

        HandleValidateAuth (Err _) ->
            { model | isLoading = False, errorState = genericError }
                ! [ newUrl "/auth/validation/error" ]

        -- Maps
        LoadMaps (Ok value) ->
            let
                maps =
                    case Json.Decode.decodeValue (Json.Decode.list keyMapDecoder) value of
                        Ok collection ->
                            collection

                        Err err ->
                            Debug.log ("Could not parse maps json `" ++ err ++ "`") []
            in
                { model | isLoading = False, keymaps = maps } ! []

        LoadMaps (Err _) ->
            -- TODO
            { model | isLoading = False } ! []
