module Views.Root exposing (view)

import Html exposing (..)
import Model.Types exposing (Model)


view : Model -> Html msg
view _ =
    div
        []
        [ text "Hello world!" ]
