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
        "site:build"
      ]

  phony "format" $ do
    cmd_ "nix fmt"

  phony "clean" $ do
    need
      [ "backend:clean",
        "site:clean"
      ]
    removeFilesAfter "_build" ["//*"]

  -- Backend

  phony "backend:build" $ do
    cmd_ "cabal build exe:backend"
    cmd_ "mkdir -p bin"
    StdoutTrim (bin :: String) <- cmd "cabal list-bin exe:backend"
    cmd_ "cp" [bin] "bin/backend"

  phony "backend:clean" $ do
    removeFilesAfter "dist-newstyle" ["//*"]
    removeFilesAfter "bin" ["//*"]

  -- Site

  phony "site:build" $ do
    cmd_ "cabal run exe:site build"

  phony "site:clean" $ do
    cmd_ "cabal run exe:site clean"
