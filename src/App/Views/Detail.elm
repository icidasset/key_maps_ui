module Views.Detail exposing (view)

import Html exposing (..)
import Model.Types exposing (Model, Msg)


view : Model -> String -> Html Msg
view model mapName =
    let
        -- TODO: Make case insensitive
        keyMap =
            model.collection
                |> List.filter (\m -> m.name == mapName)
                |> List.head

        items =
            keyMap
                |> Maybe.map (\m -> m.items)
                |> Maybe.map (\m -> Maybe.withDefault [] m)
                |> Maybe.withDefault []
                |> List.map (\i -> li [] [ text i.id ])
    in
        ul
            []
            items
