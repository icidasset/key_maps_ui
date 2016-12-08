module Views.Root exposing (view)

import Html exposing (..)
import Model.Types exposing (Model, Msg(..), Page(..))
import Model.Utils
import Views.Auth
import Views.AuthScreen
import Views.Detail
import Views.Index
import Views.LoadingScreen


view : Model -> Html Msg
view model =
    case model.isLoading of
        True ->
            isLoading model

        False ->
            isNotLoading model


isLoading : Model -> Html Msg
isLoading model =
    Views.LoadingScreen.view


isNotLoading : Model -> Html Msg
isNotLoading model =
    case model.currentPage of
        AuthExchangeFailure ->
            Views.Auth.exchangeFailure model

        AuthStartFailure ->
            Views.Auth.startFailure model

        AuthStartSuccess ->
            Views.Auth.startSuccess model

        _ ->
            requireAuthentication model


requireAuthentication : Model -> Html Msg
requireAuthentication model =
    if model.authenticatedWith == Nothing then
        Views.AuthScreen.view SetAuthEmail StartAuth
    else
        case model.currentPage of
            Index ->
                Views.Index.view model

            Detail encodedMapName ->
                encodedMapName
                    |> Model.Utils.decodeMapName
                    |> Views.Detail.view model

            _ ->
                text "Page not found."
