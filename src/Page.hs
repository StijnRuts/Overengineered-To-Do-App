{-# LANGUAGE OverloadedStrings #-}

module Page where

import Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes as A

pageHtml :: Html
pageHtml =
  docTypeHtml ! lang "en" $ do
    H.head $ do
      meta ! charset "utf-8"
      H.title "Home | To Do"
      meta ! name "viewport" ! content "width=device-width, initial-scale=1"
      meta ! name "color-scheme" ! content "light dark"
      link ! rel "stylesheet" ! href "/css/main.css"
      meta ! name "description" ! content "An Overengineered To Do App"
      meta ! name "keywords" ! content "todo list"
      link ! rel "alternate" ! hreflang "nl" ! href "/nl"
      faviconsHtml
      link ! rel "manifest" ! href "/site.webmanifest"
    body $ do
      header $ nav headerNavigationHtml
      main "placeholder content"
      footer $ nav footerNavigationHtml

faviconsHtml :: Html
faviconsHtml = do
  link ! rel "icon" ! href "/favicon.ico"
  link ! rel "icon" ! type_ "image/svg+xml" ! href "/favicon.svg"
  link ! rel "icon" ! type_ "image/png" ! sizes "32x32" ! href "/favicon/32.png"
  link ! rel "icon" ! type_ "image/png" ! sizes "16x16" ! href "/favicon/16.png"
  link ! rel "apple-touch-icon" ! sizes "180x180" ! href "/favicon/180.png"

headerNavigationHtml :: Html
headerNavigationHtml =
  ul $ do
    li $ a ! href "/" $ "Home"
    li $ a ! href "/about" $ "About"
    li $ a ! href "/blog" $ "Blog"

footerNavigationHtml :: Html
footerNavigationHtml = ul $ do
  li $ a ! href "/policy/disclaimer" $ "Disclaimer"
  li $ a ! href "/policy/privacy" $ "Privacy Policy"
  li $ a ! href "/policy/cookies" $ "Cookies Policy"
