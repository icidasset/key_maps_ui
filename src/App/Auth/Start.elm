module Auth.Start exposing (doStart)

import Http exposing (jsonBody)
import Json.Encode exposing (object, string)
import Model.Types exposing (Model, Msg(..))
import Utils


doStart : Model -> Cmd Msg
doStart model =
    let
        url =
            model.apiHost ++ "/auth/start"

        email =
            Maybe.withDefault "" model.authEmail

        requestBody =
            [ ( "email", Json.Encode.string email ) ]
                |> object
                |> jsonBody
    in
        Http.send
            (HandleStartAuth)
            (Http.request
                { method = "POST"
                , headers = []
                , url = url
                , body = requestBody
                , expect = Http.expectStringResponse expecter
                , timeout = Nothing
                , withCredentials = False
                }
            )



-- Private


expecter response =
    case response.status.code of
        200 ->
            Ok ()

        _ ->
            Err (Utils.decodeJsonError response.body)
