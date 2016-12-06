module Views.Index exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onWithOptions)
import Json.Decode as Json
import Model.Types exposing (KeyMap, Model, Msg(GoToMap))
import Regex


view : Model -> Html Msg
view model =
    div
        [ class "blocks" ]
        [ div
            [ class "blocks__row" ]
            [ div
                [ class "block" ]
                (list model)
            , div
                [ class "block" ]
                (sidebar model)
            ]
        ]



-- List


list : Model -> List (Html Msg)
list model =
    [ h2
        [ class "is-more-subtle block__title" ]
        [ text "Maps" ]
    , div
        [ class "block__list block__list--bold" ]
        [ ul
            []
            (maps model.keymaps)
        ]
    ]


maps : List KeyMap -> List (Html Msg)
maps collection =
    List.map mapItem collection


mapItem : KeyMap -> Html Msg
mapItem item =
    li
        []
        [ a
            [ href ("maps/" ++ item.name)
            , onWithOptions "click"
                { stopPropagation = False
                , preventDefault = True
                }
                (Json.succeed (GoToMap item.name))
            ]
            [ text item.name ]
        ]



-- Sidebar


sidebar : Model -> List (Html Msg)
sidebar model =
    [ h2
        [ class "is-more-subtle block__title" ]
        [ text "Add" ]
    , Html.form
        []
        [ p
            []
            [ label
                [ for "name" ]
                [ text "Name" ]
            , input
                [ name "name"
                , placeholder "Quotes"
                , type_ "text"
                ]
                []
            ]
        , p
            []
            [ label
                [ for "config" ]
                [ text "Attributes" ]
            , textarea
                [ name "config"
                , class "with-monospace-font"
                , placeholder configPlaceholder
                ]
                []
            ]
        , p
            []
            [ button
                [ type_ "submit" ]
                [ text "Create new map" ]
            ]
        ]
    ]


configPlaceholder : String
configPlaceholder =
    """
    {
      "key": "type"
    }
    """
        |> Regex.replace (Regex.AtMost 1) (Regex.regex "\\n\\s*") (\_ -> "")
        |> Regex.replace (Regex.All) (Regex.regex "\\n\\s{4}") (\_ -> "\n")
