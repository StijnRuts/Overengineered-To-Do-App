module Website where

import SSG.Files
import SSG.Result (Result')
import Website.Page
import Website.Page.About
import Website.Page.Contact
import Website.Page.Home
import Website.Site

pages :: Result' [Page]
pages = sequenceA [homePage, aboutPage, contactPage]

files :: Result' [File]
files = map (toFile site) <$> pages
