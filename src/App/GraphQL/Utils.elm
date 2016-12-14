module GraphQL.Utils exposing (..)

import Dict
import Json.Decode
import Json.Encode
import Model.Types exposing (KeyMap)
import Regex exposing (regex)
import String.Extra as String


buildAttrVariables : KeyMap -> ( String, String )
buildAttrVariables keyMap =
    let
        types =
            Dict.toList keyMap.types

        gqlTypes =
            List.map (\( k, v ) -> "$" ++ k ++ ": " ++ v) types
                |> String.join ", "

        gqlNames =
            List.map (\( k, v ) -> k ++ ": $" ++ k) types
                |> String.join ", "
    in
        ( gqlTypes, gqlNames )


decodeGraphQL : Json.Decode.Value -> Json.Decode.Decoder a -> Maybe a
decodeGraphQL value decoder =
    case Json.Decode.decodeValue decoder value of
        Ok decodedValue ->
            Just decodedValue

        Err err ->
            value
                |> Debug.log ("Could not parse json from GraphQL response (`" ++ err ++ "`)")
                |> \_ -> Nothing
