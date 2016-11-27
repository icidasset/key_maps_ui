module Model.Types exposing (..)


type alias Model =
    { authenticatedWith : Maybe Token
    , currentPage : Page
    }


type alias Token =
    String



-- Messages


type Msg
    = Authenticate Token
    | Deauthenticate
    | SetPage Page



-- Routing


type Page
    = Index
    | SignIn
