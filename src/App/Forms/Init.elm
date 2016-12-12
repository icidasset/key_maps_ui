module Forms.Init exposing (..)

import Dict exposing (Dict)
import Form exposing (Form)
import Form.Init
import Form.Validate as V exposing (..)
import Forms.Types
import Forms.Validation
import List.Extra as List
import Model.Types exposing (Model, fakeKeyMap)
import Model.Utils


-- Add item


setCreateItemFormFields : Model -> String -> Form String Forms.Types.KeyItemForm
setCreateItemFormFields model encodedMapName =
    let
        keyMap =
            encodedMapName
                |> Model.Utils.decodeMapName
                |> Model.Utils.getMap model.collection
                |> Maybe.withDefault fakeKeyMap

        fields =
            List.map (\a -> Form.Init.setString ("attributes." ++ a) "") keyMap.attributes

        parentFields =
            [ Form.Init.setString "mapName" keyMap.name
            , Form.Init.setGroup "attributes" fields
            ]

        validation =
            keyMap.attributes
                |> List.map
                    (\a ->
                        field a string
                            |> V.map ((,) a)
                            |> V.map (\x -> [ x ])
                    )
                |> List.foldl1 (V.map2 (++))
                |> Maybe.withDefault (succeed [])
    in
        Form.initial parentFields (Forms.Validation.keyItemForm validation)
