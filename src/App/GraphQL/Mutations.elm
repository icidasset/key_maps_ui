module GraphQL.Mutations exposing (..)

import Debug
import Dict exposing (Dict)
import Form
import Forms.Types exposing (..)
import GraphQL.Http exposing (query)
import GraphQL.Utils exposing (..)
import Json.Encode as Json
import List.Extra as List
import Model.Types exposing (..)
import Model.Utils
import String.Extra exposing (replace)


createItem : Model -> Cmd Msg
createItem model =
    let
        form =
            model.createItemForm
                |> Form.getOutput
                |> Maybe.withDefault emptyKeyItemForm

        lowercaseMapName =
            String.toLower form.mapName

        keyMap =
            model.collection
                |> List.find (Model.Utils.mapFilter lowercaseMapName)
                |> Maybe.withDefault fakeKeyMap

        ( variableTypes, variableNames ) =
            GraphQL.Utils.buildAttrVariables keyMap

        mutation =
            """
              mutation _ ($map: String, VAR_TYPES) {
                createMapItem (map: $map, VAR_NAMES) {
                  id,
                  map_id,
                  attributes
                }
              }
            """

        mutationWithVariables =
            mutation
                |> replace "VAR_TYPES" variableTypes
                |> replace "VAR_NAMES" variableNames
    in
        query
            CreateMapItem
            model
            "createMapItem"
            mutationWithVariables
            ((++)
                [ ( "map", Json.string form.mapName ) ]
                (List.map (Tuple.mapSecond Json.string) form.attributes)
            )


createMap : Model -> Cmd Msg
createMap model =
    let
        form =
            model.createMapForm
                |> Form.getOutput
                |> Maybe.withDefault emptyKeyMapForm

        formTypes =
            Dict.toList form.attributes
    in
        query
            CreateMap
            model
            "createMap"
            """
              mutation _ (
                $name: String,
                $attributes: Array,
                $types: Object
              ) {
                createMap (
                  name: $name,
                  attributes: $attributes,
                  types: $types
                ) {
                  id,
                  name,
                  attributes,
                  types,
                  settings
                }
              }
            """
            [ ( "name", Json.string form.name )
            , ( "attributes", encodeAttributes formTypes )
            , ( "types", encodeTypes formTypes )
            ]


removeMap : Model -> String -> Cmd Msg
removeMap model mapId =
    query
        RemoveMap
        model
        "removeMap"
        """
          mutation _ ($id: String) {
            removeMap (id: $id) {
              id,
              name,
              attributes,
              types
            }
          }
        """
        [ ( "id", Json.string mapId ) ]


removeMapItem : Model -> String -> Cmd Msg
removeMapItem model itemId =
    query
        RemoveMapItem
        model
        "removeMapItem"
        """
          mutation _ ($id: String) {
            removeMapItem (id: $id) {
              id
            }
          }
        """
        [ ( "id", Json.string itemId ) ]


updateMap : Model -> Cmd Msg
updateMap model =
    let
        form =
            model.editMapForm
                |> Form.getOutput
                |> Maybe.withDefault emptyKeyMapWithIdForm

        formTypes =
            Dict.toList form.attributes
    in
        query
            UpdateMap
            model
            "updateMap"
            """
            mutation _ (
              $id: String,
              $name: String,
              $attributes: Array,
              $types: Object
            ) {
              updateMap (
                id: $id,
                name: $name,
                attributes: $attributes,
                types: $types
              ) {
                id,
                name,
                attributes,
                types,
                settings
              }
            }
          """
            [ ( "id", Json.string form.id )
            , ( "name", Json.string form.name )
            , ( "attributes", encodeAttributes formTypes )
            , ( "types", encodeTypes formTypes )
            ]


updateMapSettings : Model -> Dict String String -> Cmd Msg
updateMapSettings model settings =
    let
        form =
            model.sortItemsForm
                |> Form.getOutput
                |> Maybe.withDefault emptySortItemsForm
    in
        query
            UpdateMapSettings
            model
            "updateMap"
            """
            mutation _ (
              $id: String,
              $settings: Object
            ) {
              updateMap (
                id: $id,
                settings: $settings
              ) {
                id,
                name,
                attributes,
                types,
                settings
              }
            }
          """
            [ ( "id", Json.string form.mapId )
            , ( "settings"
              , settings
                    |> Dict.map (\_ -> Json.string)
                    |> Dict.toList
                    |> Json.object
              )
            ]



-- Helpers


encodeAttributes : List ( String, String ) -> Json.Value
encodeAttributes formTypes =
    formTypes
        |> List.map (Tuple.first >> Json.string)
        |> Json.list


encodeTypes : List ( String, String ) -> Json.Value
encodeTypes formTypes =
    formTypes
        |> List.map (Tuple.mapSecond Json.string)
        |> Json.object
