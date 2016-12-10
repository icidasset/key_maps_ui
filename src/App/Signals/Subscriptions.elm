module Signals.Subscriptions exposing (list)

import Model.Types exposing (Model, Msg(..))
import Signals.Ports exposing (confirm)


list : Model -> Sub Msg
list model =
    Sub.batch
        [ confirm Confirm
        ]
