module Model.Init exposing (..)

import Model.Types exposing (Model, Msg)
import Navigation
import Routing


type alias ProgramFlags =
    {}


withProgramFlags : ProgramFlags -> Navigation.Location -> ( Model, Cmd Msg )
withProgramFlags flags location =
    { authenticatedWith = Nothing
    , currentPage = Routing.locationToPage location
    }
        ! []
