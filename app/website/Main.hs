{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Website (pages)
import Website.Files (FsEntry (Directory), writeFsEntry)

main :: IO ()
main = do
  putStrLn "Writing site..."
  writeFsEntry $ Directory "_website" pages
  putStrLn "Done!"
