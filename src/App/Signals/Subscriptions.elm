module Signals.Subscriptions exposing (list)

import ContextMenu
import Model.Types exposing (Model, Msg(..))
import Signals.Ports exposing (confirm)


list : Model -> Sub Msg
list model =
    Sub.batch
        [ confirm Confirm
        , Sub.map ContextMenuMsg (ContextMenu.subscriptions model.contextMenu)
        ]
