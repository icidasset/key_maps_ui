module Auth.Validate exposing (doValidate)

import Http
import Model.Types exposing (Model, Msg(..), Token)
import Utils


doValidate : Model -> Token -> Cmd Msg
doValidate model authToken =
    let
        url =
            model.apiHost ++ "/auth/validate?token=" ++ authToken
    in
        Http.send
            (HandleValidateAuth)
            (Http.request
                { method = "GET"
                , headers = []
                , url = url
                , body = Http.emptyBody
                , expect = Http.expectStringResponse expecter
                , timeout = Nothing
                , withCredentials = False
                }
            )



-- Private


expecter response =
    case response.status.code of
        202 ->
            Ok ()

        _ ->
            Err (Utils.decodeJsonError response.body)
