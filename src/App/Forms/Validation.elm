module Forms.Validation exposing (..)

import Debug
import Dict exposing (Dict)
import Form.Error exposing (Error, ErrorValue(..))
import Form.Field
import Form.Validate exposing (..)
import Forms.Types exposing (..)
import Json.Decode as Json


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
        values =
            (Dict.values dict)
    in
        -- TODO: check if the key has no spaces in it
        if List.isEmpty values then
            Err (customError "A map must have at least one attribute")
        else
            case List.all isProperType values of
                True ->
                    Ok dict

                False ->
                    Err (customError "One of your attributes has an invalid type")


isProperType : String -> Bool
isProperType theType =
    List.member theType allowedAttributeTypes



-- Helpers


flippedCustomValidation :
    (a -> Result (Error e) b)
    -> Validation e a
    -> Validation e b
flippedCustomValidation =
    flip customValidation


trimmedString : Validation e String
trimmedString =
    map String.trim string
