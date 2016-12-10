module Forms.Validation exposing (addItemForm, createForm)

import Dict exposing (Dict)
import Form.Error exposing (Error)
import Form.Validate exposing (..)
import Forms.Types exposing (..)
import Json.Decode as Json


-- {form} Add item


addItemForm : Validation String AddItemForm
addItemForm =
    map AddItemForm
        (field "attributes" (list string))



-- {form} Create


createForm : Validation String CreateForm
createForm =
    map2 CreateForm
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
