module Website.Favicon.Favicon where

import Text.Blaze.Html5 (Html, (!))
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

faviconsHtml :: Html
faviconsHtml = do
  H.link ! A.rel "icon" ! A.href "/favicon.ico"
  H.link ! A.rel "icon" ! A.type_ "image/svg+xml" ! A.href "/favicon.svg"
  H.link ! A.rel "icon" ! A.type_ "image/png" ! A.sizes "32x32" ! A.href "/favicon/32.png"
  H.link ! A.rel "icon" ! A.type_ "image/png" ! A.sizes "16x16" ! A.href "/favicon/16.png"
  H.link ! A.rel "apple-touch-icon" ! A.sizes "180x180" ! A.href "/favicon/180.png"
