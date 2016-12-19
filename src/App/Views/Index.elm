module Views.Index exposing (view)

import Form
import Form.Input as Input
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onSubmit)
import Html.Events.Extra exposing (onClickPreventDefault)
import Json.Decode as Json
import Model.Types exposing (KeyMap, Model, Msg(..))
import Model.Utils
import Views.Utils


view : Model -> Html Msg
view model =
    div
        [ class "blocks" ]
        [ div
            [ class "blocks__row" ]
            [ div
                [ class "block" ]
                [ div
                    [ class "block__input" ]
                    (List.map (Html.map HandleCreateMapForm) (sidebar model))
                ]
            , div
                [ class "block" ]
                (list model)
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
    collection
        |> List.sortBy .name
        |> List.map mapItem


mapItem : KeyMap -> Html Msg
mapItem item =
    li
        []
        [ a
            [ href ("maps/" ++ Model.Utils.encodeMapName item.name)
            , onClickPreventDefault (GoToMap item.name)
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
                (Form.getFieldAsString "name" model.createMapForm)
                [ placeholder "Quotes" ]
            ]
        , p
            []
            [ label
                [ for "attributes" ]
                [ text "Attributes" ]
            , Input.textArea
                (Form.getFieldAsString "attributes" model.createMapForm)
                [ class "with-monospace-font"
                , placeholder Views.Utils.typesPlaceholder
                ]
            ]
        , Views.Utils.formErrors model.createMapForm model.createMapServerError
        , p
            []
            [ button
                [ type_ "submit" ]
                [ text "Create new map" ]
            ]
        ]
    ]
