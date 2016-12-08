module GraphQL.Mutations exposing (..)

import Debug
import Dict
import Form
import Forms.Types exposing (..)
import GraphQL.Http exposing (query)
import Json.Encode as Json
import Model.Types exposing (KeyMap, Model, Msg(..))
import Regex exposing (regex)
import String.Extra exposing (replace)


create : Model -> Cmd Msg
create model =
    let
        mutation =
            """
              mutation M {
                createMap(
                  name: {{name}},
                  attributes: {{attributes}},
                  types: {{types}}
                ) {
                  id,
                  name,
                  attributes,
                  types
                }
              }
            """

        form =
            case Form.getOutput model.createForm of
                Just o ->
                    o

                Nothing ->
                    emptyCreateForm

        formTypes =
            Dict.toList form.attributes

        name =
            form.name
                |> Json.string
                |> Json.encode 0

        attributes =
            formTypes
                |> List.map (Tuple.first >> Json.string)
                |> Json.list
                |> Json.encode 0

        types =
            formTypes
                |> List.map (Tuple.mapSecond Json.string)
                |> Json.object
                |> Json.encode 0
                |> jsonObjectToGqlObject

        mutationWithVariables =
            mutation
                |> replace "{{name}}" name
                |> replace "{{attributes}}" attributes
                |> replace "{{types}}" types
    in
        query CreateMap model "createMap" mutationWithVariables



-- Helpers


jsonObjectToGqlObject : String -> String
jsonObjectToGqlObject =
    let
        fn =
            \{ match, submatches } ->
                case List.head submatches of
                    Just (Just x) ->
                        x ++ ":"

                    _ ->
                        match
    in
        Regex.replace Regex.All (regex "\"(\\w+)\":") fn
