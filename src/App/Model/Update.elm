module Model.Update exposing (withMessage)

import Auth.Start
import Http exposing (Error(..))
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

        HandleExchangeAuth (Ok token) ->
            { model | isLoading = False, authenticatedWith = Just token }
                ! [ modifyUrl "/", storeAuthToken token ]

        HandleExchangeAuth (Err (BadPayload err _)) ->
            { model | isLoading = False, errorState = err }
                ! [ newUrl "/auth/exchange/error" ]

        HandleExchangeAuth (Err _) ->
            { model | isLoading = False, errorState = genericError }
                ! [ newUrl "/auth/exchange/error" ]

        HandleValidateAuth (Ok _) ->
            { model | isLoading = False }
                ! []

        HandleValidateAuth (Err (BadPayload err _)) ->
            { model | isLoading = False, errorState = err }
                ! [ newUrl "/auth/validation/error" ]

        HandleValidateAuth (Err _) ->
            { model | isLoading = False, errorState = genericError }
                ! [ newUrl "/auth/validation/error" ]
