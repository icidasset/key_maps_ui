module GraphQL.Http exposing (query)

import Http exposing (header)
import Json.Decode as Json
import Model.Types exposing (Model, Msg)
import String.Extra as String


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
                , expect = Http.expectJson (jsonDecoder queryName)
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


jsonDecoder : String -> Json.Decoder Json.Value
jsonDecoder queryName =
    Json.at [ "data", queryName ] Json.value
