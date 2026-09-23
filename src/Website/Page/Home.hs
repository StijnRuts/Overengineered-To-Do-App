module Website.Page.Home where

import qualified Text.Blaze.Html5 as H
import Website.Page

homePage :: PageParams
homePage =
  PageParams
    { pageTitle = "Home",
      pageContent = do
        H.h2 "The future of getting things done has arrived!"
        H.p "Introducing the world's most focused task-management platform."
        H.p "Our proprietary innovation engine transforms \"buy milk\" into a clear, actionable checkbox. "
          <> "Mark it complete and watch the status change in real time."
        H.p "Explore the <a href=\"/blog\">blog</a> for additional insights from the rapidly expanding field of putting things on a list."
    }
