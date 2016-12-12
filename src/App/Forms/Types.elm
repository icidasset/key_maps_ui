module Forms.Types exposing (..)

import Dict exposing (Dict)
import Form exposing (Form)


-- Constants


allowedAttributeTypes : List String
allowedAttributeTypes =
    [ "String"
    , "Text"
    , "Number"
    ]



-- Forms


type alias KeyItemForm =
    { attributes : Dict String String }


emptyKeyItemForm : KeyItemForm
emptyKeyItemForm =
    { attributes = Dict.empty }


type alias KeyMapForm =
    { name : String
    , attributes : Dict String String
    }


type alias KeyMapWithIdForm =
    { id : String
    , name : String
    , attributes : Dict String String
    }


emptyKeyMapForm : KeyMapForm
emptyKeyMapForm =
    { name = ""
    , attributes = Dict.empty
    }


emptyKeyMapWithIdForm : KeyMapWithIdForm
emptyKeyMapWithIdForm =
    { id = ""
    , name = ""
    , attributes = Dict.empty
    }
