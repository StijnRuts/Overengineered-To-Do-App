{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import SSG.Files (writeFiles)
import SSG.Result (Result (..))
import Website (files)

main :: IO ()
main = do
  putStrLn "Writing site..."
  case files of
    Failed errors warnings -> do
      mapM_ (putStrLn . ("Error: " <>)) errors
      mapM_ (putStrLn . ("Warning: " <>)) warnings
      exitFailure
    Success warnings outputFiles -> do
      mapM_ (putStrLn . ("Warning: " <>)) warnings
      writeFiles "_website" outputFiles
      if null warnings
        then putStrLn "Done!"
        else exitFailure
