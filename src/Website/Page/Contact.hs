module Website.Page.Contact where

import qualified Text.Blaze.Html5 as H
import Website.Page

contactPage :: PageParams
contactPage =
  PageParams
    { pageTitle = "Contact",
      pageContent = H.p "I live in a small hut in the mountains and would not like to be contacted."
    }
