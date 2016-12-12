module Model.Init exposing (..)

import Auth.Flow exposing (authFlow)
import Form
import Forms.Validation exposing (emptyDictionaryValidation)
import Model.Types exposing (Model, Msg)
import Navigation
import Routing
import Set


type alias ProgramFlags =
    { authToken : Maybe String
    , pathToRoot : String
    }


withProgramFlags : ProgramFlags -> Navigation.Location -> ( Model, Cmd Msg )
withProgramFlags flags location =
    let
        emptyKeyItemForm =
            Forms.Validation.keyItemForm emptyDictionaryValidation

        model =
            { apiHost = "https://keymaps.herokuapp.com"
            , collection = []
            , currentPage = Routing.locationToPage location
            , errorState = ""
            , isLoading = False
            , loadedItemsFromMaps = Set.empty
            , pathToRoot = flags.pathToRoot
            , ---------------------------------------
              -- Authentication
              ---------------------------------------
              authenticatedWith = flags.authToken
            , authEmail = Nothing
            , ---------------------------------------
              -- Dialogs
              ---------------------------------------
              confirm = Nothing
            , ---------------------------------------
              -- Forms
              ---------------------------------------
              createItemForm = Form.initial [] emptyKeyItemForm
            , createItemServerError = Nothing
            , createMapForm = Form.initial [] Forms.Validation.keyMapForm
            , createMapServerError = Nothing
            , editMapForm = Form.initial [] Forms.Validation.keyMapWithIdForm
            , editMapServerError = Nothing
            }
    in
        authFlow model location
