module Views.Index exposing (view)

import Form
import Form.Input as Input
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onSubmit, onWithOptions)
import Json.Decode as Json
import Model.Types exposing (KeyMap, Model, Msg(..))
import Model.Utils
import Regex
import Views.Utils


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
                (List.map (Html.map HandleCreateForm) (sidebar model))
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
            (maps model.collection)
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
            [ href ("maps/" ++ Model.Utils.encodeMapName item.name)
            , onWithOptions "click"
                { stopPropagation = False
                , preventDefault = True
                }
                (Json.succeed (GoToMap item.name))
            ]
            [ text item.name ]
        ]



-- Sidebar


sidebar : Model -> List (Html Form.Msg)
sidebar model =
    [ h2
        [ class "is-more-subtle block__title" ]
        [ text "Add" ]
    , Html.form
        [ onSubmit Form.Submit ]
        [ p
            []
            [ label
                [ for "name" ]
                [ text "Name" ]
            , Input.textInput
                (Form.getFieldAsString "name" model.createForm)
                [ placeholder "Quotes" ]
            ]
        , p
            []
            [ label
                [ for "attributes" ]
                [ text "Attributes" ]
            , Input.textArea
                (Form.getFieldAsString "attributes" model.createForm)
                [ class "with-monospace-font"
                , placeholder typesPlaceholder
                ]
            ]
        , Views.Utils.formErrors model.createForm model.createServerError
        , p
            []
            [ button
                [ type_ "submit" ]
                [ text "Create new map" ]
            ]
        ]
    ]


typesPlaceholder : String
typesPlaceholder =
    """
    {
      "key": "type"
    }
    """
        |> Regex.replace (Regex.AtMost 1) (Regex.regex "\\n\\s*") (\_ -> "")
        |> Regex.replace (Regex.All) (Regex.regex "\\n\\s{4}") (\_ -> "\n")
