module Views.Maps.Detail exposing (view)

import Dict exposing (Dict)
import Form
import Form.Input as Input
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onSubmit)
import Html.Events.Extra exposing (onClickPreventDefault)
import Json.Decode as Json
import Model.Types exposing (..)
import Model.Utils
import String.Extra as String
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
                    [ class "is-more-subtle block__title" ]
                    [ text "Control panel" ]
                , configPanel model keyMap
                ]
            , div
                [ class "block" ]
                [ h2
                    [ class "is-more-subtle is-colored block__title" ]
                    [ text keyMap.name ]
                , data model keyMap
                ]
            ]
        ]



-- Config panel


configPanel : Model -> KeyMap -> Html Msg
configPanel model keyMap =
    div
        [ class "blocks" ]
        [ div
            [ class "block" ]
            [ div
                [ class "block__list" ]
                [ ul
                    []
                    [ li_a
                        [ href "../../"
                        , onClickPreventDefault GoToIndex
                        ]
                        [ span [] [ text "☜" ]
                        , text "Index"
                        ]
                    , li_a
                        [ onClick (GoToEditMap keyMap.name) ]
                        [ text "Edit map" ]
                    ]
                ]
            ]
        , blockRow
            [ Html.map HandleCreateItemForm (addItemForm model keyMap) ]
        , blockRow
            [ Html.map HandleSortItemsForm (sortForm model keyMap) ]
        ]


addItemForm : Model -> KeyMap -> Html Form.Msg
addItemForm model keyMap =
    let
        form_ =
            model.createItemForm

        attributes =
            List.sort keyMap.attributes
    in
        Html.form
            [ onSubmit Form.Submit ]
            [ div
                []
                (List.map
                    (\attr ->
                        let
                            key =
                                "attributes." ++ attr

                            keyType =
                                keyMap.types
                                    |> Dict.get attr
                                    |> Maybe.map String.classify

                            field =
                                Form.getFieldAsString key form_
                        in
                            p
                                []
                                [ label
                                    [ for attr ]
                                    [ text attr ]
                                , case keyType of
                                    Just "Text" ->
                                        Input.textArea field [ placeholder "Text" ]

                                    _ ->
                                        Input.textInput field [ placeholder "String" ]
                                ]
                    )
                    attributes
                )
            , Views.Utils.formErrors model.createItemForm model.createItemServerError
            , p
                []
                [ button
                    [ type_ "submit" ]
                    [ text "Add new item" ]
                ]
            ]


sortForm : Model -> KeyMap -> Html Form.Msg
sortForm model keyMap =
    Html.form
        []
        [ label
            [ class "is-subtle" ]
            [ text "Sort by" ]
        , div
            [ class "select-box" ]
            [ Input.selectInput
                (List.map (\a -> ( a, a )) keyMap.attributes)
                (Form.getFieldAsString "sortBy" model.sortItemsForm)
                []
            ]
        ]



-- Data


data : Model -> KeyMap -> Html Msg
data model keyMap =
    let
        firstAttr =
            keyMap.attributes
                |> List.sort
                |> List.head
                |> Maybe.withDefault ""

        sortBy =
            keyMap.settings
                |> Dict.get "sortBy"
                |> Maybe.withDefault firstAttr

        items =
            Model.Utils.getMapItems (Just keyMap)
                |> List.map toKeyItemWithStringAttributes
                |> List.sortWith
                    (\a b ->
                        compare
                            (Maybe.withDefault "" (Dict.get sortBy a.attributes))
                            (Maybe.withDefault "" (Dict.get sortBy b.attributes))
                    )
    in
        if List.isEmpty items then
            div
                []
                [ em [] [ text "No items found" ] ]
        else
            div
                [ class "data-list" ]
                (List.map dataItem items)


dataItem : KeyItemWithStringAttributes -> Html Msg
dataItem item =
    div
        [ class "data-list__item" ]
        (item.attributes
            |> Dict.map dataItemAttribute
            |> Dict.values
        )


dataItemAttribute : String -> String -> Html Msg
dataItemAttribute key value =
    div
        []
        [ div
            [ class "item__label" ]
            [ text key ]
        , div
            []
            [ text value ]
        ]



-- Data :: Helpers


decodeAttributes : Dict String Json.Value -> Dict String String
decodeAttributes attributes =
    let
        decoder =
            \_ i ->
                Result.withDefault "UNPARSABLE VALUE" (Json.decodeValue Json.string i)
    in
        Dict.map decoder attributes


toKeyItemWithStringAttributes : KeyItem -> KeyItemWithStringAttributes
toKeyItemWithStringAttributes item =
    { id = item.id
    , map_id = item.map_id
    , attributes = decodeAttributes item.attributes
    }
