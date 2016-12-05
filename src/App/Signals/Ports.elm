port module Signals.Ports exposing (..)

import Model.Types exposing (Token)


-- Ports


port storeAuthToken : Token -> Cmd msg
