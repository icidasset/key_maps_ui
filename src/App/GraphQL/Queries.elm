module GraphQL.Queries exposing (..)

import GraphQL.Http exposing (query)
import Json.Encode as Json
import Model.Types exposing (KeyMap, Model, Msg(..))
import String.Extra exposing (replace)


maps : Model -> Cmd Msg
maps model =
    query LoadMaps model "maps" """
      query Q {
        maps {
          id,
          name,
          attributes,
          types
        }
      }
    """


mapItems : Model -> String -> Cmd Msg
mapItems model mapName =
    let
        qry =
            """
              query Q {
                mapItems(map: {{mapName}}) {
                  id,
                  map_id,
                  attributes
                }
              }
            """

        fn =
            mapName
                |> Json.string
                |> Json.encode 0
                |> replace "{{mapName}}"

        qryWithVariables =
            fn qry
    in
        query (LoadMapItems) model "mapItems" qryWithVariables
