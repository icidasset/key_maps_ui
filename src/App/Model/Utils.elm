module Model.Utils exposing (..)

import Http
import Json.Decode as Json
import Model.Types exposing (..)


-- Querying


getMap : List KeyMap -> String -> Maybe KeyMap
getMap collection decodedMapName =
    collection
        |> List.filter (mapFilter (String.toLower decodedMapName))
        |> List.head


getMapItems : Maybe KeyMap -> List KeyItem
getMapItems keyMap =
    keyMap
        |> Maybe.map (\m -> m.items)
        |> Maybe.map (\m -> Maybe.withDefault [] m)
        |> Maybe.withDefault []


isEmptyKeyMap : List KeyMap -> String -> Bool
isEmptyKeyMap collection decodedMapName =
    decodedMapName
        |> getMap collection
        |> getMapItems
        |> List.isEmpty


mapFilter : String -> KeyMap -> Bool
mapFilter lowercaseMapName m =
    (String.toLower m.name) == lowercaseMapName



-- Json


keyMapDecoder : Json.Decoder KeyMap
keyMapDecoder =
    Json.map5 KeyMap
        (Json.field "id" <| Json.string)
        (Json.field "name" <| Json.string)
        (Json.field "attributes" <| Json.list Json.string)
        (Json.field "types" <| Json.dict Json.string)
        (Json.maybe <| Json.field "items" (Json.list keyItemDecoder))


keyItemDecoder : Json.Decoder KeyItem
keyItemDecoder =
    Json.map3 KeyItem
        (Json.field "id" <| Json.string)
        (Json.field "map_id" <| Json.string)
        (Json.field "attributes" <| Json.dict Json.value)



-- Other


decodeMapName : String -> String
decodeMapName encodedMapName =
    Maybe.withDefault "" (Http.decodeUri encodedMapName)


encodeMapName : String -> String
encodeMapName mapName =
    Http.encodeUri mapName


mapUrl : String -> String
mapUrl mapName =
    "/maps/" ++ encodeMapName mapName


storeItem : String -> KeyItem -> KeyMap -> KeyMap
storeItem mapId item keyMap =
    if keyMap.id == mapId then
        { keyMap | items = Maybe.map (\col -> col ++ [ item ]) keyMap.items }
    else
        keyMap


storeItems : String -> List KeyItem -> KeyMap -> KeyMap
storeItems mapId items keyMap =
    if keyMap.id == mapId then
        { keyMap | items = Just items }
    else
        keyMap
