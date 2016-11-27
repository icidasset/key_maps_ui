module Views.Root exposing (view)

import Html exposing (..)
import Model.Types exposing (Model)
import Views.AuthScreen as AuthScreen


view : Model -> Html msg
view model =
    if model.authenticatedWith == Nothing then
        AuthScreen.view model
    else
        div [] [ text "Hello world!" ]
