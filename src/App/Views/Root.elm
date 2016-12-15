module Views.Root exposing (view)

import Color
import ContextMenu
import Html exposing (..)
import Html.Attributes exposing (class)
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



-- To load or not to load


isLoading : Model -> Html Msg
isLoading model =
    Views.LoadingScreen.view


isNotLoading : Model -> Html Msg
isNotLoading model =
    div
        []
        [ case model.currentPage of
            AuthExchangeFailure ->
                Views.Auth.exchangeFailure model

            AuthStartFailure ->
                Views.Auth.startFailure model

            AuthStartSuccess ->
                Views.Auth.startSuccess model

            _ ->
                requireAuthentication model
          --
          -- Context menu
        , div
            [ class "context-menu" ]
            [ ContextMenu.view
                contextMenuConfig
                ContextMenuMsg
                contextMenuItems
                model.contextMenu
            ]
        ]



-- Require authentication


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

            CouldNotRemoveItem ->
                Views.MessageScreen.view "Could not remove item."

            CouldNotRemoveMap ->
                Views.MessageScreen.view "Could not remove map."

            _ ->
                text "Page not found."



-- Context menus


contextMenuConfig : ContextMenu.Config
contextMenuConfig =
    let
        defaultConfig =
            ContextMenu.defaultConfig
    in
        { defaultConfig
            | hoverColor = Color.rgba 123 189 164 0.05
        }


contextMenuItems : Context -> List (List ( ContextMenu.Item, Msg ))
contextMenuItems context =
    case context of
        MapItemContext k ->
            [ [ ( ContextMenu.item "Remove", ConfirmToRemoveItem k.map_id k.id )
              ]
            ]
