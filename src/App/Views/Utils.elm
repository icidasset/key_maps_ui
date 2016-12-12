module Views.Utils exposing (..)

import Form exposing (Form)
import Form.Error exposing (ErrorValue(..))
import Html exposing (Html, a, div, li, p, span, text)
import Html.Attributes exposing (class)
import Model.Types exposing (Model, Msg)
import Regex
import String.Extra exposing (humanize)
import Views.Icon


blockFiller : Model -> List (Html.Attribute Msg) -> String -> String -> Html Msg
blockFiller model attributes icon label =
    a
        ([ class "block block--filler" ] ++ attributes)
        [ span
            [ class "block--filler__inner" ]
            [ Views.Icon.view model icon
            , span [] [ text label ]
            ]
        ]


blockRow : List (Html Msg) -> Html Msg
blockRow children =
    div
        [ class "blocks__row" ]
        [ div
            [ class "block" ]
            children
        ]


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


li_a : List (Html.Attribute Msg) -> List (Html Msg) -> Html Msg
li_a attr children =
    li [] [ a attr children ]


typesPlaceholder : String
typesPlaceholder =
    """
    {
      "key": "String | Text | Number"
    }
    """
        |> Regex.replace (Regex.AtMost 1) (Regex.regex "\\n\\s*") (\_ -> "")
        |> Regex.replace (Regex.All) (Regex.regex "\\n\\s{4}") (\_ -> "\n")
