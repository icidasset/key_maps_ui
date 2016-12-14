module GraphQL.Http exposing (query)

import Http exposing (header)
import Json.Decode
import Json.Encode
import Model.Types exposing (Model, Msg)
import String.Extra as String
import Utils


type alias QueryMsg =
    Result Http.Error Json.Decode.Value -> Msg


type alias Variables =
    List ( String, Json.Encode.Value )


query : QueryMsg -> Model -> String -> String -> Variables -> Cmd Msg
query msg model queryName query variables =
    let
        url =
            model.apiHost ++ "/api"

        authToken =
            Maybe.withDefault "" model.authenticatedWith

        json =
            Json.Encode.object
                [ ( "operationName", Json.Encode.string "_" )
                , ( "query", Json.Encode.string query )
                , ( "variables", Json.Encode.object variables )
                ]
    in
        Http.send
            (msg)
            (Http.request
                { method = "POST"
                , headers = [ header "Authorization" authToken ]
                , url = url
                , body = Http.jsonBody json
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


expecter : String -> Http.Response String -> Result String Json.Decode.Value
expecter queryName response =
    -- GraphQL error becomes Http error
    case Json.Decode.decodeString Utils.jsonErrorsDecoder response.body of
        Ok err ->
            Err err

        _ ->
            -- GraphQL data becomes Json.Value
            Json.Decode.decodeString (jsonDataDecoder queryName) response.body


jsonDataDecoder : String -> Json.Decode.Decoder Json.Decode.Value
jsonDataDecoder queryName =
    Json.Decode.at [ "data", queryName ] Json.Decode.value
