module GraphQL.Http exposing (query)

import Http exposing (header)
import Json.Decode as Json
import Model.Types exposing (Model, Msg)
import String.Extra as String
import Utils


query : (Result Http.Error Json.Value -> Msg) -> Model -> String -> String -> Cmd Msg
query msg model queryName query =
    let
        url =
            model.apiHost ++ "/api?query=" ++ (encodeQuery query)

        authToken =
            Maybe.withDefault "" model.authenticatedWith
    in
        Http.send
            (msg)
            (Http.request
                { method = "GET"
                , headers = [ header "Authorization" authToken ]
                , url = url
                , body = Http.emptyBody
                , expect = Http.expectStringResponse (expecter queryName)
                , timeout = Nothing
                , withCredentials = False
                }
            )



-- Private


encodeQuery : String -> String
encodeQuery query =
    query
        |> String.trim
        |> String.clean
        |> Http.encodeUri


expecter : String -> Http.Response String -> Result String Json.Value
expecter queryName response =
    -- GraphQL error becomes Http error
    case Json.decodeString Utils.jsonErrorsDecoder response.body of
        Ok err ->
            Err err

        _ ->
            -- GraphQL data becomes Json.Value
            Json.decodeString (jsonDataDecoder queryName) response.body


jsonDataDecoder : String -> Json.Decoder Json.Value
jsonDataDecoder queryName =
    Json.at [ "data", queryName ] Json.value
