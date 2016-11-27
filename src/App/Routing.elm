module Routing exposing (locationToMessage, locationToPage)

import Model.Types exposing (..)
import Navigation
import UrlParser exposing (Parser, (</>), map, oneOf, s)


{-| Parse the location and return a `Msg`.
-}
locationToMessage : Navigation.Location -> Msg
locationToMessage location =
    location
        |> locationToPage
        |> SetPage


{-| Parse the location and return a `Page`.
-}
locationToPage : Navigation.Location -> Page
locationToPage location =
    location
        |> UrlParser.parsePath route
        |> Maybe.withDefault Index



-- Private


route : Parser (Page -> a) a
route =
    oneOf
        [ map SignIn (s "sign-in")
        , map Index (s "")
        ]
