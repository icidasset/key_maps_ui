module Auth.Flow exposing (authFlow)

import Auth.Exchange as Auth
import Auth.Validate as Auth
import Model.Types exposing (Model, Msg)
import Navigation


authFlow : Model -> Navigation.Location -> ( Model, Cmd Msg )
authFlow model location =
    case Auth.hasExchangeError location of
        Just err ->
            { model | errorState = err } ! goToExchangeErrorPage

        Nothing ->
            case exchangeValidateOrPass model location of
                Just cmd ->
                    { model | isLoading = True } ! [ cmd ]

                Nothing ->
                    model ! []



-- Private


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
