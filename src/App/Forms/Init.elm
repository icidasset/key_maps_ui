module Forms.Init exposing (..)

import Dict exposing (Dict)
import Form exposing (Form)
import Form.Init
import Form.Validate as V exposing (..)
import Forms.Types
import Forms.Validation
import Json.Encode
import List.Extra as List
import Model.Types exposing (Model, fakeKeyMap)
import Model.Utils


-- Create item


setCreateItemFormFields : Model -> String -> Form String Forms.Types.KeyItemForm
setCreateItemFormFields model encodedMapName =
    let
        keyMap =
            encodedMapName
                |> Model.Utils.decodeMapName
                |> Model.Utils.getMap model.collection
                |> Maybe.withDefault fakeKeyMap

        fields =
            List.map
                (\a -> Form.Init.setString ("attributes." ++ a) "")
                keyMap.attributes

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



-- Edit map


setEditMapFormFields : Model -> String -> Form String Forms.Types.KeyMapWithIdForm
setEditMapFormFields model encodedMapName =
    let
        keyMap =
            encodedMapName
                |> Model.Utils.decodeMapName
                |> Model.Utils.getMap model.collection
                |> Maybe.withDefault fakeKeyMap

        types =
            keyMap.types
                |> Dict.map (\k v -> Json.Encode.string v)
                |> Dict.toList
                |> Json.Encode.object
                |> Json.Encode.encode 2

        fields =
            [ Form.Init.setString "id" keyMap.id
            , Form.Init.setString "name" keyMap.name
            , Form.Init.setString "attributes" types
            ]
    in
        Form.update (Form.Reset fields) model.editMapForm



-- Sort map items


setSortItemsFormFields : Model -> String -> Form String Forms.Types.SortItemsForm
setSortItemsFormFields model encodedMapName =
    let
        keyMap =
            encodedMapName
                |> Model.Utils.decodeMapName
                |> Model.Utils.getMap model.collection
                |> Maybe.withDefault fakeKeyMap

        firstAttr =
            keyMap.attributes
                |> List.sort
                |> List.head
                |> Maybe.withDefault ""

        sortBy =
            keyMap.settings
                |> Dict.get "sortBy"
                |> Maybe.withDefault firstAttr

        fields =
            [ Form.Init.setString "mapId" keyMap.id
            , Form.Init.setString "sortBy" sortBy
            ]
    in
        Form.update (Form.Reset fields) model.sortItemsForm
