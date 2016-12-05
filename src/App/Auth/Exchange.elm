module Auth.Exchange exposing (doExchange, hasExchangeError, needsExchange)

import Http exposing (jsonBody)
import Json.Decode
import Json.Encode exposing (object)
import Model.Types exposing (Model, Msg(..))
import Navigation
import QueryString exposing (one, string)


needsExchange : Navigation.Location -> Maybe String
needsExchange location =
    QueryString.parse location.hash
        |> one string "id_token"


hasExchangeError : Navigation.Location -> Maybe String
hasExchangeError location =
    QueryString.parse location.hash
        |> one string "error_description"


doExchange : Model -> String -> Cmd Msg
doExchange model idToken =
    let
        url =
            model.apiHost ++ "/auth/exchange"

        requestBody =
            [ ( "auth0_id_token", Json.Encode.string idToken ) ]
                |> object
                |> jsonBody
    in
        Http.send
            (HandleExchangeAuth)
            (Http.post url requestBody exchangeDecoder)



-- Private


exchangeDecoder : Json.Decode.Decoder String
exchangeDecoder =
    Json.Decode.field "data" (Json.Decode.field "token" Json.Decode.string)
