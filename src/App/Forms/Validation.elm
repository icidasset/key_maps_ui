module Forms.Validation exposing (..)

import Dict exposing (Dict)
import Form.Error exposing (Error, ErrorValue(..))
import Form.Field
import Form.Validate exposing (..)
import Forms.Types exposing (..)
import Json.Decode as Json
import Regex exposing (regex)
import String.Extra as String


-- {forms} Item


keyItemForm : Validation String (List ( String, String )) -> Validation String KeyItemForm
keyItemForm attributesValidation =
    map2 KeyItemForm
        (field "mapName" string)
        (field "attributes" attributesValidation)



-- {forms} Map


keyMapForm : Validation String KeyMapForm
keyMapForm =
    map2 KeyMapForm
        (field "name" trimmedString)
        (field "attributes" typesValidation)


keyMapWithIdForm : Validation String KeyMapWithIdForm
keyMapWithIdForm =
    map3 KeyMapWithIdForm
        (field "id" string)
        (field "name" trimmedString)
        (field "attributes" typesValidation)


typesValidation : Validation String (Dict String String)
typesValidation =
    string
        |> flippedCustomValidation typesJsonValidator
        |> flippedCustomValidation typesValidator


typesJsonValidator : String -> Result (Error String) (Dict String String)
typesJsonValidator json =
    json
        |> Json.decodeString (Json.dict Json.string)
        |> Result.mapError customError


typesValidator : Dict String String -> Result (Error String) (Dict String String)
typesValidator dict =
    let
        keys =
            Dict.keys dict

        values =
            Dict.values dict
    in
        if List.isEmpty values then
            Err <| err "A map must have at least one attribute"
        else if List.any isInvalidKey keys then
            Err <| err """
                         Keys can only contain alphanumeric characters,
                         underscores and dashes
                       """
        else
            case List.all isProperType values of
                True ->
                    Ok dict

                False ->
                    Err <| err "One of your attributes has an invalid type"


isProperType : String -> Bool
isProperType theType =
    List.member theType allowedAttributeTypes


isInvalidKey : String -> Bool
isInvalidKey theKey =
    Regex.contains (regex "[^\\w-]") theKey



-- Helpers


err : String -> Error String
err errorMessage =
    errorMessage
        |> String.clean
        |> customError


flippedCustomValidation :
    (a -> Result (Error e) b)
    -> Validation e a
    -> Validation e b
flippedCustomValidation =
    flip customValidation


trimmedString : Validation e String
trimmedString =
    map String.trim string
