module Views.Utils exposing (..)

import Form exposing (Form)
import Form.Error exposing (ErrorValue(..))
import Html exposing (Html, p, text)
import Html.Attributes exposing (class)
import String.Extra exposing (humanize)


formErrors : Form String o -> Html Form.Msg
formErrors form =
    if Form.isSubmitted form then
        p
            [ class "form__error" ]
            [ case List.head (Form.getErrors form) of
                Just ( label, err ) ->
                    case err of
                        CustomError e ->
                            text (e ++ ".")

                        InvalidString ->
                            text (humanize label ++ " cannot be empty.")

                        _ ->
                            text ("The field `" ++ humanize label ++ "` is invalid.")

                _ ->
                    text ""
            ]
    else
        text ""
