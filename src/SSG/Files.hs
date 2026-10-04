module SSG.Files where

import qualified Data.ByteString.Lazy as LBS
import System.Directory
  ( createDirectoryIfMissing,
  )
import System.FilePath (takeDirectory, (</>))
import Text.Blaze.Html.Renderer.Utf8 (renderHtml)
import Text.Blaze.Html5 (Html)

data File = File FilePath LBS.ByteString

htmlFile :: FilePath -> Html -> File
htmlFile path html = File path (renderHtml html)

htmlPage :: FilePath -> Html -> File
htmlPage path = htmlFile (dropWhile (== '/') path </> "index.html")

writeFiles :: FilePath -> [File] -> IO ()
writeFiles basePath = mapM_ writeFileEntry
  where
    writeFileEntry (File path content) = do
      let fullPath = basePath </> path
      putStrLn ("Writing " <> fullPath)
      createDirectoryIfMissing True (takeDirectory fullPath)
      writeFileLBS fullPath content
