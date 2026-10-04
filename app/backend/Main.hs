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

data Field a = Field
  { defaultValue :: Set a,
    explicitValue :: Set a
  }

instance Functor Field where
  fmap f (Field default' explicit) =
    Field (fmap f default') (fmap f explicit)

instance Applicative Field where
  pure value = Field None (Once value)
  functions <*> values =
    case (valueOf functions, valueOf values) of
      (Just f, Just value) -> pure (f value)
      _ -> Field None None

instance Semigroup (Field a) where
  Field oldDefaults oldExplicit <> Field newDefaults newExplicit =
    Field (oldDefaults <> newDefaults) (oldExplicit <> newExplicit)

instance Monoid (Field a) where
  mempty = Field None None

valueOf :: Field a -> Maybe a
valueOf (Field fallbackValues None) = valueOfSet fallbackValues
valueOf (Field _ explicit) = valueOfSet explicit

isNone :: Field a -> Bool
isNone = isNothing . valueOf

isManyDefault :: Field a -> Bool
isManyDefault (Field (Many _) _) = True
isManyDefault _ = False

isManyExplicit :: Field a -> Bool
isManyExplicit (Field _ (Many _)) = True
isManyExplicit _ = False

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

valueOfSet :: Set a -> Maybe a
valueOfSet None = Nothing
valueOfSet (Once value) = Just value
valueOfSet (Many value) = Just value

--------

type Partial a = HKD a Field

type Update a = Partial a -> Partial a

type Builder a = Update a -> Logger String String a

type LabelExtractor a = (forall b. Field b -> Bool) -> Partial a -> [String]

builder :: forall a. (Monoid (Partial a), Construct Field a) => LabelExtractor a -> Builder a
builder labels updates =
  let initial :: Partial a
      initial = mempty @(Partial a)
      values = updates initial
      missing = labels isNone values
      repeatedDefaults = labels isManyDefault values
      repeatedExplicits = labels isManyExplicit values
      warnings =
        map ("Default set more than once: " <>) repeatedDefaults
          <> map ("Field set more than once: " <>) repeatedExplicits
   in case valueOf (construct values) of
        Just result -> Success warnings result
        Nothing -> Failed ("Missing fields " <> intercalate ", " missing)

set :: Lens' (HKD structure Field) (Field a) -> a -> HKD structure Field -> HKD structure Field
set lens value u = u & lens %~ (<> Field None (Once value))

setDefault :: Lens' (HKD structure Field) (Field a) -> a -> HKD structure Field -> HKD structure Field
setDefault lens value u = u & lens %~ (<> Field (Once value) None)

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
defaults = setDefault (field @"likesDogs") True

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

user5 :: Logger String String User
user5 =
  mkUser $
    setDefault (field @"likesDogs") False
      . set (field @"name") "Lorem Ipsum"
      . set (field @"age") 42

main :: IO ()
main = do
  print user1
  print user2
  print user3
  print user4
  print user5
