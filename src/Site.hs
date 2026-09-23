{-# LANGUAGE OverloadedStrings #-}

import qualified Data.ByteString.Lazy as LBS
import System.Directory
  ( createDirectoryIfMissing,
  )
import System.FilePath ((</>))
import Text.Blaze.Html.Renderer.Utf8 (renderHtml)
import Text.Blaze.Html5 (Html, (!))
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

data FsEntry
  = File FilePath LBS.ByteString
  | Directory FilePath [FsEntry]

layout :: Html -> Html
layout content = H.docTypeHtml $ H.body content

homePage :: Html
homePage =
  layout $ do
    H.h1 "Welcome"
    H.p "This page was generated statically."
    H.p $ do
      "Read more on the "
      H.a ! A.href "/about.html" $ "about page"

aboutPage :: Html
aboutPage =
  layout $ do
    H.h1 "About"
    H.p "This is a small static site built with Blaze HTML."

site :: [FsEntry]
site =
  [ File "home.html" (renderHtml homePage),
    File "about.html" (renderHtml aboutPage)
  ]

writeFsEntry :: FsEntry -> IO ()
writeFsEntry = writeFsEntryAt ""
  where
    writeFsEntryAt parent (File fileName content) = do
      let path = parent </> fileName
      putStrLn ("Writing " <> path)
      writeFileLBS path content
    writeFsEntryAt parent (Directory directoryName entries) = do
      let path = parent </> directoryName
      putStrLn ("Writing " <> path <> "/")
      createDirectoryIfMissing True path
      mapM_ (writeFsEntryAt path) entries

main :: IO ()
main = do
  putStrLn "Writing site..."
  writeFsEntry $ Directory "_site" site
  putStrLn "Done!"
