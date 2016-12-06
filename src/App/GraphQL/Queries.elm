module GraphQL.Queries exposing (..)

import GraphQL.Http exposing (query)
import Model.Types exposing (KeyMap, Model, Msg(..))


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
