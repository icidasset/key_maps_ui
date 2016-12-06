module Model.Types exposing (..)

import Dict exposing (Dict)
import Json.Decode as Json
import Http


type alias Model =
    { apiHost : String
    , authenticatedWith : Maybe Token
    , authEmail : Maybe String
    , currentPage : Page
    , errorState : String {- Error state (generic) -}
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
    = Authenticate Token
    | Deauthenticate
    | GoToMap String
    | HandleStartAuth (Result Http.Error ())
    | HandleExchangeAuth (Result Http.Error String)
    | HandleValidateAuth (Result Http.Error ())
    | LoadMaps (Result Http.Error Json.Value)
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
    | NotFound
    | SignIn
