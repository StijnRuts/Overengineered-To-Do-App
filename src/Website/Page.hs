{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeApplications #-}

module Website.Page where

import Data.Generic.HKD (field, labelsWhere)
import SSG.Builder (Builder, Update, builder, setDefault)
import SSG.Files (File, htmlPage)
import SSG.URL (URL (..))
import Text.Blaze.Html5 (Html, (!))
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A
import Website.Site (Site)
import qualified Website.Site as Site

data Page
  = Page
  { url :: URL,
    title :: String,
    language :: String,
    description :: String,
    keywords :: [String],
    content :: Html
  }
  deriving (Generic)

new :: Builder Page
new updates = builder labelsWhere (updates . defaults)

defaults :: Update Page
defaults =
  setDefault (field @"language") "en"
    . setDefault (field @"description") ""
    . setDefault (field @"keywords") []

toFile :: Site -> Page -> File
toFile site page = htmlPage (unURL $ page.url) (template site page)

template :: Site -> Page -> Html
template site page =
  H.docTypeHtml ! A.lang (H.toValue page.language) $ do
    H.head $ do
      H.meta ! A.charset "utf-8"
      H.title $ H.toHtml (site.title page.title)
      H.meta ! A.name "viewport" ! A.content "width=device-width, initial-scale=1"
      H.meta ! A.name "color-scheme" ! A.content "light dark"
      -- H.link ! A.rel "stylesheet" ! A.href "/css/main.css"
      H.meta ! A.name "description" ! A.content
        (H.toValue $ if null page.description then site.description else page.description)
      H.meta ! A.name "keywords" ! A.content
        (H.toValue $ intercalate ", " $ if null page.keywords then site.keywords else page.keywords)
    -- H.link ! A.rel "alternate" ! A.hreflang "nl" ! A.href "/nl"
    -- faviconsHtml
    -- H.link ! A.rel "manifest" ! A.href "/site.webmanifest"
    H.body $ do
      -- header $ nav headerNavigationHtml
      H.main page.content
      -- footer $ nav footerNavigationHtml
