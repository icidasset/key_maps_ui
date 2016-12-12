module GraphQL.Utils exposing (..)

import Json.Decode
import Json.Encode
import Regex exposing (regex)
import String.Extra as String


decodeGraphQL : Json.Decode.Value -> Json.Decode.Decoder a -> Maybe a
decodeGraphQL value decoder =
    case Json.Decode.decodeValue decoder value of
        Ok decodedValue ->
            Just decodedValue

        Err err ->
            value
                |> Debug.log ("Could not parse json from GraphQL response (`" ++ err ++ "`)")
                |> \_ -> Nothing


insertVariables : String -> String -> List ( String, Json.Encode.Value ) -> String
insertVariables query queryName variables =
    let
        variableMapper =
            \( key, value ) ->
                let
                    k =
                        String.replace ".obj" "" key

                    v =
                        if String.contains ".obj" key then
                            jsonObjectToGqlObject (Json.Encode.encode 0 value)
                        else
                            Json.Encode.encode 0 value
                in
                    k ++ ": " ++ v

        joinedVariables =
            variables
                |> List.map variableMapper
                |> String.join ", "
    in
        String.replace
            (queryName ++ "()")
            (if List.isEmpty variables then
                queryName
             else
                queryName ++ "(" ++ joinedVariables ++ ")"
            )
            (query)


jsonObjectToGqlObject : String -> String
jsonObjectToGqlObject =
    let
        fn =
            \{ match, submatches } ->
                case List.head submatches of
                    Just (Just x) ->
                        x ++ ":"

                    _ ->
                        match
    in
        Regex.replace Regex.All (regex "\"(\\w+)\":") fn
