module Website.Files where

import qualified Data.ByteString.Lazy as LBS
import System.Directory
  ( createDirectoryIfMissing,
  )
import System.FilePath ((</>))
import Text.Blaze.Html.Renderer.Utf8 (renderHtml)
import Text.Blaze.Html5 (Html)

data FsEntry
  = File FilePath LBS.ByteString
  | Directory FilePath [FsEntry]

htmlFile :: FilePath -> Html -> FsEntry
htmlFile path html = File path (renderHtml html)

htmlPage :: FilePath -> Html -> FsEntry
htmlPage "" html = htmlFile "index.html" html
htmlPage path html = Directory path [htmlFile "index.html" html]

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
