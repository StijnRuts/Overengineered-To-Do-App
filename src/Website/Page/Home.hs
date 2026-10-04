{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeApplications #-}

module Website.Page.Home where

import Data.Generic.HKD (field)
import SSG.Builder (set)
import SSG.Result (Result')
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A
import Website.Page

homePage :: Result' Page
homePage =
  new $
    set (field @"title") "Home"
      . set (field @"url") "/"
      . set
        (field @"content")
        ( do
            H.h2 "The future of getting things done has arrived!"
            H.p "Introducing the world's most focused task-management platform."
            H.p
              ( "Our proprietary innovation engine transforms \"buy milk\" into a clear, actionable checkbox. "
                  <> "Mark it complete and watch the status change in real time."
              )
            H.p $
              "Explore the "
                <> (H.a H.! A.href "/blog" $ "blog")
                <> " for additional insights from the rapidly expanding field of putting things on a list."
        )
