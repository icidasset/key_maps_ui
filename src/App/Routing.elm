module Routing exposing (locationToMessage, locationToPage)

import Model.Types exposing (..)
import Navigation
import UrlParser exposing (..)


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
        |> Maybe.withDefault NotFound



-- Private


route : Parser (Page -> a) a
route =
    oneOf
        [ -- Authentication
          map AuthExchangeFailure (s "auth" </> s "exchange" </> s "error")
        , map AuthStartFailure (s "auth" </> s "start" </> s "error")
        , map AuthStartSuccess (s "auth" </> s "start" </> s "success")
        , map SignIn (s "sign-in")
          --
        , map Detail (s "maps" </> string)
        , map Index top
        ]
