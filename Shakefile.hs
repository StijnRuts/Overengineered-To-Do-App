import Development.Shake
import Development.Shake.Command
import Development.Shake.FilePath
import Development.Shake.Util

main :: IO ()
main = shakeArgs shakeOptions {shakeFiles = "_build"} $ do
  -- Project

  want ["build"]

  phony "build" $ do
    need
      [ "backend:build",
        "website:build"
      ]

  phony "format" $ do
    cmd_ "nix fmt"

  phony "clean" $ do
    need
      [ "backend:clean",
        "website:clean"
      ]
    removeFilesAfter "_build" ["//*"]

  -- Backend

  phony "backend:build" $ do
    cmd_ "cabal build exe:backend"
    cmd_ "mkdir -p _bin"
    StdoutTrim (bin :: String) <- cmd "cabal list-bin exe:backend"
    cmd_ "cp" [bin] "_bin/backend"

  phony "backend:clean" $ do
    removeFilesAfter "dist-newstyle" ["//*"]
    removeFilesAfter "_bin" ["//*"]

  -- Website

  phony "website:build" $ do
    cmd_ "cabal run exe:website"

  phony "website:clean" $ do
    removeFilesAfter "_website" ["//*"]
    removeFilesAfter "_cache" ["//*"]
