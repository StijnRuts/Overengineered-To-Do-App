{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE NoMonoLocalBinds #-}
{-# OPTIONS_GHC -Wno-simplifiable-class-constraints #-}

module Main where

import Control.Lens (Lens', (.~))
import Data.Generic.HKD

--------

type Partial a = HKD a Last

type Update a = Partial a -> Partial a

type Builder a = Update a -> Either String a

type LabelExtractor a = (forall b. Last b -> Bool) -> Partial a -> [String]

builder :: forall a. (Monoid (Partial a), Construct Last a) => LabelExtractor a -> Builder a
builder labels updates =
  let initial :: Partial a
      initial = mempty @(Partial a)
      values = updates initial
      missing = labels (isNothing . getLast) values
   in maybeToRight ("Missing fields " <> intercalate ", " missing) (getLast $ construct values)

set :: (Applicative f) => Lens' (HKD structure f) (f a) -> a -> HKD structure f -> HKD structure f
set lens value u = u & lens .~ pure value

--------

data User
  = User
  { name :: String,
    age :: Int,
    likesDogs :: Bool
  }
  deriving (Generic, Show)

mkUser :: Builder User
mkUser updates = builder labelsWhere (updates . defaults)

defaults :: Update User
defaults = set (field @"likesDogs") True

user1 :: Either String User
user1 =
  mkUser $
    set (field @"name") "Lorem Ipsum"
      . set (field @"age") 42
      . set (field @"likesDogs") False

user2 :: Either String User
user2 =
  mkUser $
    set (field @"name") "Lorem Ipsum"
      . set (field @"likesDogs") True

user3 :: Either String User
user3 =
  mkUser $
    set (field @"name") "Lorem Ipsum"
      . set (field @"age") 42

main :: IO ()
main = do
  print user1
  print user2
  print user3
