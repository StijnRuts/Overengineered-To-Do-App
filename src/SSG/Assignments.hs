module SSG.Assignments where

import SSG.Container (Container (..))

data Assignments a
  = None
  | Once a
  | Many a
  deriving (Show)

instance Functor Assignments where
  fmap _ None = None
  fmap f (Once x) = Once (f x)
  fmap f (Many x) = Many (f x)

instance Semigroup (Assignments a) where
  a <> None = a
  None <> Once x = Once x
  _ <> Once x = Many x
  _ <> Many x = Many x

instance Monoid (Assignments a) where
  mempty = None

instance Container Assignments where
  valueOf None = Nothing
  valueOf (Once x) = Just x
  valueOf (Many x) = Just x

isNone :: Assignments a -> Bool
isNone None = True
isNone _ = False

isOnce :: Assignments a -> Bool
isOnce (Once _) = True
isOnce _ = False

isMany :: Assignments a -> Bool
isMany (Many _) = True
isMany _ = False
