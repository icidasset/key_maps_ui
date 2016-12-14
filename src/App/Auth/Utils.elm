module Auth.Utils exposing (..)

import Json.Decode as Json
import Jwt
import Result


getUserIdFromToken : String -> Maybe Int
getUserIdFromToken token =
    Jwt.decodeToken
        (Json.at [ "user", "id" ] Json.int)
        (token)
        |> Result.toMaybe
