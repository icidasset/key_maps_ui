module Model.Types exposing (..)

import Dict exposing (Dict)
import Form exposing (Form)
import Forms.Types exposing (Forms)
import Json.Decode as Json
import Http


type alias Model =
    { apiHost : String
    , authenticatedWith : Maybe Token
    , authEmail : Maybe String
    , currentPage : Page
    , errorState : String {- Error state (generic) -}
    , forms : Forms
    , isLoading : Bool
    , keymaps : List KeyMap
    }


type alias Token =
    String



-- Data


type alias KeyMap =
    { id : String
    , name : String
    , attributes : List String
    , types : Dict String String
    }


keyMapDecoder : Json.Decoder KeyMap
keyMapDecoder =
    Json.map4 KeyMap
        (Json.field "id" <| Json.string)
        (Json.field "name" <| Json.string)
        (Json.field "attributes" <| Json.list Json.string)
        (Json.field "types" <| Json.dict Json.string)


type alias KeyItem =
    { id : String
    , map_id : String
    , attributes : Dict String Json.Value
    }



-- Messages


type Msg
    = GoToMap String
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
    | CreateMap (Result Http.Error Json.Value)
    | LoadMaps (Result Http.Error Json.Value)



-- Routing


type Page
    = Index
    | LoadingScreen
    | NotFound
      -- Authentication
    | AuthExchangeFailure
    | AuthStartFailure
    | AuthStartSuccess
    | SignIn
