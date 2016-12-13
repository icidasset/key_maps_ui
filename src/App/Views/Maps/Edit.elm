module Views.Maps.Edit exposing (view)

import Form
import Form.Input as Input
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onSubmit)
import Html.Events.Extra exposing (onClickPreventDefault)
import Model.Types exposing (..)
import Views.Utils exposing (blockRow, li_a)


view : Model -> KeyMap -> Html Msg
view model keyMap =
    div
        [ class "blocks" ]
        [ div
            [ class "blocks__row" ]
            [ div
                [ class "block" ]
                [ h2
                    [ class "is-more-subtle is-colored block__title" ]
                    [ text keyMap.name ]
                , leftSide model keyMap
                ]
            , div
                [ class "block" ]
                [ h2
                    [ class "is-more-subtle block__title" ]
                    [ text "Edit" ]
                , Html.map HandleEditMapForm (rightSide model keyMap)
                ]
            ]
        ]



-- Left


leftSide : Model -> KeyMap -> Html Msg
leftSide model keyMap =
    div
        [ class "blocks" ]
        [ div
            [ class "block" ]
            [ div
                [ class "block__list" ]
                [ ul
                    []
                    [ li_a
                        [ href "../"
                        , onClickPreventDefault (GoToMap keyMap.name)
                        ]
                        [ span [] [ text "☜" ]
                        , text "Index"
                        ]
                    ]
                ]
            ]
        ]



-- Right


rightSide : Model -> KeyMap -> Html Form.Msg
rightSide model keyMap =
    Html.form
        [ onSubmit Form.Submit ]
        [ p
            []
            [ label
                [ for "name" ]
                [ text "Name" ]
            , Input.textInput
                (Form.getFieldAsString "name" model.editMapForm)
                [ placeholder keyMap.name ]
            ]
        , p
            []
            [ label
                [ for "attributes" ]
                [ text "Attributes" ]
            , Input.textArea
                (Form.getFieldAsString "attributes" model.editMapForm)
                [ class "with-monospace-font"
                , placeholder Views.Utils.typesPlaceholder
                ]
            ]
        , Views.Utils.formErrors model.editMapForm model.editMapServerError
        , p
            []
            [ button
                [ type_ "submit" ]
                [ text "Save" ]
            ]
        ]
