module Model.Init exposing (..)

import ContextMenu
import Auth.Flow exposing (authFlow)
import Auth.Utils
import Form
import Form.Validate
import Forms.Validation
import Model.Types exposing (Model, Msg(..))
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
            Forms.Validation.keyItemForm (Form.Validate.succeed [])

        {- Context menu -}
        ( contextMenu, contextMsg ) =
            ContextMenu.init

        {- Model -}
        model =
            { apiHost = location.protocol ++ "//keymaps.herokuapp.com"
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
            , userId = Maybe.andThen Auth.Utils.getUserIdFromToken flags.authToken
            , ---------------------------------------
              -- Dialogs & menus
              ---------------------------------------
              confirm = Nothing
            , contextMenu = contextMenu
            , ---------------------------------------
              -- Forms
              ---------------------------------------
              createItemForm = Form.initial [] emptyKeyItemForm
            , createItemServerError = Nothing
            , createMapForm = Form.initial [] Forms.Validation.keyMapForm
            , createMapServerError = Nothing
            , editMapForm = Form.initial [] Forms.Validation.keyMapWithIdForm
            , editMapServerError = Nothing
            , sortItemsForm = Form.initial [] Forms.Validation.sortItemsForm
            }

        {- Auth flow -}
        ( modelAfterAuthFlow, cmdAfterAuthFlow ) =
            authFlow model location
    in
        (!)
            modelAfterAuthFlow
            [ cmdAfterAuthFlow, Cmd.map ContextMenuMsg contextMsg ]
