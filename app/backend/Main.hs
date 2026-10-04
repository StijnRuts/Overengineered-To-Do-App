{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE NoMonoLocalBinds #-}
{-# OPTIONS_GHC -Wno-simplifiable-class-constraints #-}

module Main where

import Control.Lens (Lens', (%~))
import Data.Generic.HKD
import Prelude hiding (Set)

--------

data Logger error warning a
  = Failed error
  | Success [warning] a
  deriving (Show)

--------

data Set a
  = None
  | Once a
  | Many a
  deriving (Show)

instance Functor Set where
  fmap _ None = None
  fmap f (Once value) = Once (f value)
  fmap f (Many value) = Many (f value)

instance Applicative Set where
  pure = Once
  None <*> _ = None
  _ <*> None = None
  Once f <*> Once value = Once (f value)
  Once f <*> Many value = Many (f value)
  Many f <*> Once value = Many (f value)
  Many f <*> Many value = Many (f value)

instance Semigroup (Set a) where
  None <> value = value
  value <> None = value
  Once _ <> Once value = Many value
  Once _ <> Many value = Many value
  Many _ <> Once value = Many value
  Many _ <> Many value = Many value

instance Monoid (Set a) where
  mempty = None

valueOf :: Set a -> Maybe a
valueOf None = Nothing
valueOf (Once value) = Just value
valueOf (Many value) = Just value

isNone :: Set a -> Bool
isNone None = True
isNone _ = False

isMany :: Set a -> Bool
isMany (Many _) = True
isMany _ = False

--------

type Partial a = HKD a Set

type Update a = Partial a -> Partial a

type Builder a = Update a -> Logger String String a

type LabelExtractor a = (forall b. Set b -> Bool) -> Partial a -> [String]

builder :: forall a. (Monoid (Partial a), Construct Set a) => LabelExtractor a -> Builder a
builder labels updates =
  let initial :: Partial a
      initial = mempty @(Partial a)
      values = updates initial
      missing = labels isNone values
      repeated = labels isMany values
   in case valueOf (construct values) of
      Just result -> Success (map ("Field set more than once: " <>) repeated) result
      Nothing -> Failed ("Missing fields " <> intercalate ", " missing)

set :: (Applicative f, Semigroup (f a)) => Lens' (HKD structure f) (f a) -> a -> HKD structure f -> HKD structure f
set lens value u = u & lens %~ (<> pure value)

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

user1 :: Logger String String User
user1 =
  mkUser $
    set (field @"name") "Lorem Ipsum"
      . set (field @"age") 42
      . set (field @"likesDogs") False

user2 :: Logger String String User
user2 =
  mkUser $
    set (field @"name") "Lorem Ipsum"
      . set (field @"likesDogs") True

user3 :: Logger String String User
user3 =
  mkUser $
    set (field @"name") "Lorem Ipsum"
      . set (field @"age") 42

user4 :: Logger String String User
user4 =
  mkUser $
    set (field @"name") "Lorem Ipsum"
      . set (field @"name") "Lorem Ipsum"
      . set (field @"age") 42

main :: IO ()
main = do
  print user1
  print user2
  print user3
  print user4
