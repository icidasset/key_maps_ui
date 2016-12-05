module Pages.Proxy where

import Template
import qualified Data.Text as Text (append)


template :: Template
template obj _ = mconcat
  [ container_
      [ class_ "elm-container" ] ↩
      []

  , script_
      [ src_ $ Text.append (obj ⚡⚡ "pathToRoot") ("application.js") ]
      ( "" )

  , script_
      [ src_ $ Text.append (obj ⚡⚡ "pathToRoot") ("elm-loader.js") ]
      ( "" )
  ]
