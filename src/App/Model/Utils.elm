module Model.Utils exposing (..)

import Http
import Json.Decode as Json
import Model.Types exposing (..)
import Set


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


haveMapItemsBeenLoaded : Model -> String -> Bool
haveMapItemsBeenLoaded model encodedMapName =
    encodedMapName
        |> decodeMapName
        |> getMap model.collection
        |> Maybe.withDefault fakeKeyMap
        |> .id
        |> (flip Set.member) model.loadedItemsFromMaps


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
    Json.map6 KeyMap
        (Json.field "id" <| Json.string)
        (Json.field "name" <| Json.string)
        (Json.field "attributes" <| Json.list Json.string)
        (Json.field "types" <| Json.dict Json.string)
        (Json.field "settings" <| Json.dict Json.string)
        (Json.maybe <| Json.field "items" (Json.list keyItemDecoder))


keyItemDecoder : Json.Decoder KeyItem
keyItemDecoder =
    Json.map3 KeyItem
        (Json.field "id" <| Json.string)
        (Json.field "map_id" <| Json.string)
        (Json.field "attributes" <| Json.dict Json.value)



-- Other


buildLiveJsonUrl : Int -> KeyMap -> String
buildLiveJsonUrl userId keyMap =
    "https://keymaps.herokuapp.com/public/"
        ++ toString userId
        ++ "/"
        ++ encodeMapName keyMap.name


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
        { keyMap | items = Just <| item :: (Maybe.withDefault [] keyMap.items) }
    else
        keyMap


storeItems : String -> List KeyItem -> KeyMap -> KeyMap
storeItems mapId items keyMap =
    if keyMap.id == mapId then
        { keyMap | items = Just items }
    else
        keyMap
