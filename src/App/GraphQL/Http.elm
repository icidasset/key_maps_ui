module GraphQL.Http exposing (query)

import GraphQL.Utils exposing (insertVariables)
import Http exposing (header)
import Json.Decode as Json
import Model.Types exposing (Model, Msg)
import String.Extra as String
import Utils


type alias QueryMsg =
    Result Http.Error Json.Value -> Msg


type alias Variables =
    List ( String, Json.Value )


query : QueryMsg -> Model -> String -> String -> Variables -> Cmd Msg
query msg model queryName query variables =
    let
        queryWithVariables =
            insertVariables query queryName variables

        url =
            model.apiHost ++ "/api?query=" ++ (encodeQuery queryWithVariables)

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
