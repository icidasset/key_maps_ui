module Forms.Types exposing (..)

import Dict exposing (Dict)
import Form exposing (Form)


-- Constants


allowedAttributeTypes : List String
allowedAttributeTypes =
    [ "String"
    , "Number"
    ]



-- Group


type alias Forms =
    { create : Form String CreateForm
    }



-- Children


type alias CreateForm =
    { name : String
    , attributes : Dict String String
    }


emptyCreateForm : CreateForm
emptyCreateForm =
    { name = ""
    , attributes = Dict.empty
    }
