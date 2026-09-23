module Website where

import Website.Files
import Website.Page
import Website.Page.About
import Website.Page.Contact
import Website.Page.Home
import Website.Site

pages :: [FsEntry]
pages =
  [ htmlPage "" (pageTemplate siteParams homePage),
    htmlPage "about" (pageTemplate siteParams aboutPage),
    htmlPage "contact" (pageTemplate siteParams contactPage)
  ]
