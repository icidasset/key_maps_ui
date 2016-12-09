module Views.Detail exposing (view)

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onWithOptions)
import Json.Decode as Json
import Model.Types exposing (..)
import Model.Utils


view : Model -> String -> Html Msg
view model mapName =
    div
        [ class "blocks" ]
        [ div
            [ class "blocks__row" ]
            [ div
                [ class "block" ]
                [ h2
                    [ class "is-more-subtle block__title" ]
                    [ text "Control panel" ]
                , configPanel model mapName
                ]
            , div
                [ class "block" ]
                [ h2
                    [ class "is-more-subtle block__title" ]
                    [ text "Data" ]
                , data model mapName
                ]
            ]
        ]



-- Data


data : Model -> String -> Html Msg
data model mapName =
    let
        keyMap =
            Model.Utils.getMap model.collection mapName

        items =
            Model.Utils.getMapItems keyMap
    in
        if List.isEmpty items then
            div
                []
                [ em [] [ text "No items found" ] ]
        else
            div
                [ class "data-list" ]
                (List.map dataItem items)


dataItem : KeyItem -> Html Msg
dataItem item =
    div
        [ class "data-list__item" ]
        (item.attributes
            |> decodeAttributes
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



-- Config panel


configPanel : Model -> String -> Html Msg
configPanel model mapName =
    div
        [ class "block__list" ]
        [ ul
            []
            [ lia
                [ href "../../"
                , onWithOptions "click"
                    { stopPropagation = False
                    , preventDefault = True
                    }
                    (Json.succeed GoToIndex)
                ]
                [ span [] [ text "☜" ]
                , text "Back to index"
                ]
            , lia [] [ text "Remove map" ]
            ]
        ]


lia : List (Html.Attribute Msg) -> List (Html Msg) -> Html Msg
lia attr children =
    li [] [ a attr children ]
