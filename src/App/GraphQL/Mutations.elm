module GraphQL.Mutations exposing (..)

import Debug
import Dict exposing (Dict)
import Form
import Forms.Types exposing (..)
import GraphQL.Http exposing (query)
import GraphQL.Utils exposing (..)
import Json.Encode as Json
import Model.Types exposing (KeyMap, Model, Msg(..))
import String.Extra exposing (replace)


createItem : Model -> Cmd Msg
createItem model =
    let
        form =
            model.createItemForm
                |> Form.getOutput
                |> Maybe.withDefault emptyKeyItemForm
    in
        query
            CreateMapItem
            model
            "createMapItem"
            """
              mutation M {
                createMapItem() {
                  id,
                  map_id,
                  attributes
                }
              }
            """
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
              mutation M {
                createMap() {
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
            , ( "types.obj", encodeTypes formTypes )
            ]


removeMap : Model -> String -> Cmd Msg
removeMap model mapId =
    query
        RemoveMap
        model
        "removeMap"
        """
          mutation M {
            removeMap() {
              id,
              name,
              attributes,
              types
            }
          }
        """
        [ ( "id", Json.string mapId ) ]


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
            mutation M {
              updateMap() {
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
            , ( "types.obj", encodeTypes formTypes )
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
            mutation M {
              updateMap() {
                id,
                name,
                attributes,
                types,
                settings
              }
            }
          """
            [ ( "id", Json.string form.mapId )
            , ( "settings.obj"
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
