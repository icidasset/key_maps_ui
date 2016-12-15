module Views.Root exposing (view)

import Html exposing (..)
import Model.Types exposing (..)
import Model.Utils
import Views.Auth
import Views.AuthScreen
import Views.Index
import Views.LoadingScreen
import Views.Maps.Detail
import Views.Maps.Edit
import Views.MessageScreen


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
            DetailMap encodedMapName ->
                encodedMapName
                    |> Model.Utils.decodeMapName
                    |> Model.Utils.getMap model.collection
                    |> Maybe.withDefault fakeKeyMap
                    |> Views.Maps.Detail.view model

            EditMap encodedMapName ->
                encodedMapName
                    |> Model.Utils.decodeMapName
                    |> Model.Utils.getMap model.collection
                    |> Maybe.withDefault fakeKeyMap
                    |> Views.Maps.Edit.view model

            Index ->
                Views.Index.view model

            -- Errors
            CouldNotLoadMap ->
                Views.MessageScreen.view "Map not found."

            CouldNotLoadMaps ->
                Views.MessageScreen.view "Could not load maps."

            CouldNotRemoveMap ->
                Views.MessageScreen.view "Could not remove map."

            _ ->
                text "Page not found."
