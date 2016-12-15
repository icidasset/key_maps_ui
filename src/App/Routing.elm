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
          -- Errors
        , map CouldNotLoadMaps (s "errors" </> s "maps")
        , map CouldNotLoadMap (s "errors" </> s "map")
        , map CouldNotRemoveMap (s "errors" </> s "map" </> s "remove")
          --
        , map DetailMap (s "maps" </> string)
        , map EditMap (s "maps" </> string </> s "edit")
        , map Index top
        ]
