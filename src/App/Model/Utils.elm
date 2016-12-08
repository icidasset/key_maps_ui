module Model.Utils exposing (..)

import Http
import Json.Decode as Json
import Model.Types exposing (..)


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
