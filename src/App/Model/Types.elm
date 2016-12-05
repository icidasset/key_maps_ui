module Model.Types exposing (..)

import Http


type alias Model =
    { apiHost : String
    , authenticatedWith : Maybe Token
    , authEmail : Maybe String
    , currentPage : Page
    , errorState : String {- Error state (generic) -}
    , isLoading : Bool
    }


type alias Token =
    String



-- Messages


type Msg
    = Authenticate Token
    | Deauthenticate
    | HandleStartAuth (Result Http.Error ())
    | HandleExchangeAuth (Result Http.Error String)
    | HandleValidateAuth (Result Http.Error ())
    | SetAuthEmail String
    | SetPage Page
    | StartAuth



-- Routing


type Page
    = AuthExchangeFailure
    | AuthStartFailure
    | AuthStartSuccess
    | Index
    | LoadingScreen
    | SignIn
