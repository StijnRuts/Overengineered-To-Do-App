{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeApplications #-}

module Website.Page.Contact where

import Data.Generic.HKD (field)
import SSG.Builder (set)
import SSG.Result (Result')
import qualified Text.Blaze.Html5 as H
import Website.Page

contactPage :: Result' Page
contactPage =
  new $
    set (field @"title") "Contact"
      . set (field @"url") "/contact"
      . set (field @"content") (H.p "I live in a small hut in the mountains and would not like to be contacted.")
