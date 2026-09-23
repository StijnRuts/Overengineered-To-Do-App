module Website.Page where

import Text.Blaze.Html5 (Html, (!))
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A
import Website.Site

data PageParams = PageParams
  { pageTitle :: String,
    pageContent :: Html
  }

pageTemplate :: SiteParams -> PageParams -> Html
pageTemplate config pageParams =
  H.docTypeHtml ! A.lang "en" $ do
    H.head $ do
      H.meta ! A.charset "utf-8"
      H.title $
        H.toHtml
          (pageTitle pageParams <> " | " <> siteTitle config)
      H.meta ! A.name "viewport" ! A.content "width=device-width, initial-scale=1"
      H.meta ! A.name "color-scheme" ! A.content "light dark"
      -- H.link ! A.rel "stylesheet" ! A.href "/css/main.css"
      H.meta ! A.name "description" ! A.content (H.toValue $ siteDescription config)
      H.meta ! A.name "keywords" ! A.content (H.toValue $ siteKeywords config)
    -- H.link ! A.rel "alternate" ! A.hreflang "nl" ! A.href "/nl"
    -- faviconsHtml
    -- H.link ! A.rel "manifest" ! A.href "/site.webmanifest"
    H.body $ do
      -- header $ nav headerNavigationHtml
      H.main (pageContent pageParams)

-- footer $ nav footerNavigationHtml
