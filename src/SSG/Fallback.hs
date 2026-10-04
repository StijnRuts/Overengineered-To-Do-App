{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE QuantifiedConstraints #-}
{-# LANGUAGE UndecidableInstances #-}

module SSG.Fallback where

import Control.Lens (Lens', lens)
import SSG.Container (Container (..))
import Prelude

data Fallback f a = Fallback (f a) (f a)

instance (Functor f) => Functor (Fallback f) where
  fmap f (Fallback d e) = Fallback (fmap f d) (fmap f e)

instance (Semigroup (f a)) => Semigroup (Fallback f a) where
  Fallback d1 e1 <> Fallback d2 e2 = Fallback (d1 <> d2) (e1 <> e2)

instance (Monoid (f a)) => Monoid (Fallback f a) where
  mempty = Fallback mempty mempty

instance (Container f) => Container (Fallback f) where
  valueOf (Fallback d e) = if isEmpty e then valueOf d else valueOf e

_default :: Lens' (Fallback f a) (f a)
_default = lens getDefault setDefault
  where
    getDefault (Fallback d _) = d
    setDefault (Fallback _ e) d = Fallback d e

_explicit :: Lens' (Fallback f a) (f a)
_explicit = lens getExplicit setExplicit
  where
    getExplicit (Fallback _ e) = e
    {- HLINT ignore setExplicit "Eta reduce" -}
    setExplicit (Fallback d _) e = Fallback d e
