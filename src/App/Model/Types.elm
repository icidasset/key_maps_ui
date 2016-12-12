module Model.Types exposing (..)

import Dict exposing (Dict)
import Form exposing (Form)
import Forms.Types exposing (..)
import Http
import Json.Decode as Json
import Set exposing (Set)


type alias Model =
    { apiHost : String
    , collection : List KeyMap
    , currentPage : Page
    , errorState : String {- Error state (generic) -}
    , isLoading : Bool
    , loadedItemsFromMaps : Set String
    , pathToRoot : String
    , ---------------------------------------
      -- Authentication
      ---------------------------------------
      authenticatedWith : Maybe Token
    , authEmail : Maybe String
    , ---------------------------------------
      -- Dialogs
      ---------------------------------------
      confirm : Maybe Confirmation
    , ---------------------------------------
      -- Forms
      ---------------------------------------
      createItemForm : Form String KeyItemForm
    , createItemServerError : Maybe String
    , createMapForm : Form String KeyMapForm
    , createMapServerError : Maybe String
    , editMapForm : Form String KeyMapWithIdForm
    , editMapServerError : Maybe String
    }


type alias Token =
    String


type alias Confirmation =
    { ok : Msg
    }



-- Data


type alias KeyMap =
    { id : String
    , name : String
    , attributes : List String
    , types : Dict String String
    , -- Local
      items : Maybe (List KeyItem)
    }


fakeKeyMap : KeyMap
fakeKeyMap =
    { id = "0"
    , name = "FAKE"
    , attributes = []
    , types = Dict.empty
    , items = Nothing
    }


type alias KeyItem =
    { id : String
    , map_id : String
    , attributes : Dict String Json.Value
    }



-- Messages


type Msg
    = -- Dialogs
      Confirm Bool
    | ConfirmToRemoveMap String
      -- Authentication
    | Authenticate Token
    | Deauthenticate
    | HandleStartAuth (Result Http.Error ())
    | HandleExchangeAuth (Result Http.Error String)
    | HandleValidateAuth (Result Http.Error ())
    | SetAuthEmail String
    | StartAuth
      -- Forms
    | HandleCreateItemForm Form.Msg
    | HandleCreateMapForm Form.Msg
    | HandleEditMapForm Form.Msg
      -- GraphQL
    | CreateMap GraphQLResult
    | CreateMapItem GraphQLResult
    | UpdateMap GraphQLResult
    | LoadMaps GraphQLResult
    | LoadMapItems GraphQLResult
    | RemoveMap GraphQLResult
      -- GraphQL :: Execution
    | ExecRemoveMap String
      -- Navigation
    | GoToEditMap String
    | GoToIndex
    | GoToMap String
    | SetPage Page


type alias GraphQLResult =
    Result Http.Error Json.Value



-- Routing


type Page
    = Index
    | DetailMap String
    | EditMap String
    | NotFound
      -- Errors
    | CouldNotLoadMap
    | CouldNotLoadMaps
      -- Authentication
    | AuthExchangeFailure
    | AuthStartFailure
    | AuthStartSuccess
    | SignIn
