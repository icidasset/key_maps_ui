module Model.Update exposing (withMessage)

import Model.Types exposing (..)


-- Update


withMessage : Msg -> Model -> ( Model, Cmd Msg )
withMessage msg model =
    case msg of
        SetPage page ->
            { model | currentPage = page } ! []

        -- Auth
        Authenticate token ->
            { model | authenticatedWith = Just token } ! []

        Deauthenticate ->
            { model | authenticatedWith = Nothing } ! []
