port module Signals.Ports exposing (..)

import Model.Types exposing (Token)


-- Send


port askForConfirmation : String -> Cmd msg


port storeAuthToken : Token -> Cmd msg



-- Listen


port confirm : (Bool -> msg) -> Sub msg
