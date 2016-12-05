module Views.Auth exposing (..)

import Html exposing (..)
import Model.Types exposing (Model, Msg)
import Views.MessageScreen


exchangeFailure : Model -> Html Msg
exchangeFailure model =
    Views.MessageScreen.view model.errorState


startFailure : Model -> Html Msg
startFailure model =
    Views.MessageScreen.view model.errorState


startSuccess : Model -> Html Msg
startSuccess _ =
    Views.MessageScreen.view "A login link has been sent to your email address."
