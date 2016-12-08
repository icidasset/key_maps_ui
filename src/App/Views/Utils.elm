module Views.Utils exposing (..)

import Form exposing (Form)
import Form.Error exposing (ErrorValue(..))
import Html exposing (Html, p, text)
import Html.Attributes exposing (class)
import String.Extra exposing (humanize)


formErrors : Form String o -> Maybe String -> Html Form.Msg
formErrors form maybeServerError =
    if Form.isSubmitted form then
        p
            [ class "form__error" ]
            [ case List.head (Form.getErrors form) of
                Just ( label, err ) ->
                    case err of
                        CustomError e ->
                            text (e ++ ".")

                        Empty ->
                            text (humanize label ++ " cannot be empty.")

                        InvalidString ->
                            text (humanize label ++ " cannot be empty.")

                        _ ->
                            text ("The field `" ++ humanize label ++ "` is invalid.")

                _ ->
                    case maybeServerError of
                        Just err ->
                            text (err ++ ".")

                        Nothing ->
                            text ""
            ]
    else
        text ""
