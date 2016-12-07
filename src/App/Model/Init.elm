module Model.Init exposing (..)

import Auth.Exchange as Auth
import Auth.Validate as Auth
import Form
import Forms.Validation
import Model.Types exposing (Model, Msg, Page(..))
import Navigation
import Routing


type alias ProgramFlags =
    { authToken : Maybe String }


withProgramFlags : ProgramFlags -> Navigation.Location -> ( Model, Cmd Msg )
withProgramFlags flags location =
    let
        model =
            { apiHost = "https://keymaps.herokuapp.com"
            , authenticatedWith = flags.authToken
            , authEmail = Nothing
            , currentPage = Routing.locationToPage location
            , errorState = ""
            , forms =
                { create = Form.initial [] Forms.Validation.createForm
                }
            , isLoading = False
            , keymaps = []
            }
    in
        case Auth.hasExchangeError location of
            Just err ->
                { model | errorState = err } ! goToExchangeErrorPage

            Nothing ->
                case exchangeValidateOrPass model location of
                    Just cmd ->
                        { model | isLoading = True } ! [ cmd ]

                    Nothing ->
                        model ! []



-- Authentication


goToExchangeErrorPage : List (Cmd Msg)
goToExchangeErrorPage =
    [ Navigation.newUrl "/auth/exchange/error" ]


exchangeValidateOrPass : Model -> Navigation.Location -> Maybe (Cmd Msg)
exchangeValidateOrPass model location =
    [ Maybe.map (Auth.doExchange model) (Auth.needsExchange location)
    , Maybe.map (Auth.doValidate model) (model.authenticatedWith)
    ]
        |> List.filter isJust
        |> List.head
        |> Maybe.withDefault Nothing



-- Helpers


isJust : Maybe a -> Bool
isJust m =
    case m of
        Just _ ->
            True

        Nothing ->
            False
