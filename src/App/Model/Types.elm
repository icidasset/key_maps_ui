module Model.Types exposing (..)

import Dict exposing (Dict)
import Form exposing (Form)
import Forms.Types exposing (..)
import Http
import Json.Decode as Json


type alias Model =
    { apiHost : String
    , collection : List KeyMap
    , currentPage : Page
    , errorState : String {- Error state (generic) -}
    , isLoading : Bool
    , ---------------------------------------
      -- Authentication
      ---------------------------------------
      authenticatedWith : Maybe Token
    , authEmail : Maybe String
    , ---------------------------------------
      -- Forms
      ---------------------------------------
      createForm : Form String CreateForm
    , createServerError : Maybe String
    }


type alias Token =
    String



-- Data


type alias KeyMap =
    { id : String
    , name : String
    , attributes : List String
    , types : Dict String String
    , -- Local
      items : Maybe (List KeyItem)
    }


type alias KeyItem =
    { id : String
    , map_id : String
    , attributes : Dict String Json.Value
    }



-- Messages


type Msg
    = -- Navigation
      GoToIndex
    | GoToMap String
    | SetPage Page
      -- Authentication
    | Authenticate Token
    | Deauthenticate
    | HandleStartAuth (Result Http.Error ())
    | HandleExchangeAuth (Result Http.Error String)
    | HandleValidateAuth (Result Http.Error ())
    | SetAuthEmail String
    | StartAuth
      -- Forms
    | HandleCreateForm Form.Msg
      -- GraphQL
    | CreateMap GraphQLResult
    | LoadMaps GraphQLResult
    | LoadMapItems GraphQLResult


type alias GraphQLResult =
    Result Http.Error Json.Value



-- Routing


type Page
    = Index
    | Detail String
    | LoadingScreen
    | NotFound
      -- Errors
    | CouldNotLoadMap
    | CouldNotLoadMaps
      -- Authentication
    | AuthExchangeFailure
    | AuthStartFailure
    | AuthStartSuccess
    | SignIn
