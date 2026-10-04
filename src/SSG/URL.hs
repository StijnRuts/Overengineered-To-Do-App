module SSG.URL (URL (..)) where

newtype URL = URL {unURL :: String}
  deriving (Show)

instance IsString URL where
  fromString = URL
