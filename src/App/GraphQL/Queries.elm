module GraphQL.Queries exposing (..)

import GraphQL.Http exposing (query)
import Json.Encode as Json
import Model.Types exposing (KeyMap, Model, Msg(..))
import String.Extra exposing (replace)


maps : Model -> Cmd Msg
maps model =
    query
        LoadMaps
        model
        "maps"
        """
          query Q {
            maps() {
              id,
              name,
              attributes,
              types,
              settings
            }
          }
        """
        []


mapItems : Model -> String -> Cmd Msg
mapItems model mapName =
    query
        LoadMapItems
        model
        "mapItems"
        """
          query Q {
            mapItems() {
              id,
              map_id,
              attributes
            }
          }
        """
        [ ( "map", Json.string mapName ) ]
