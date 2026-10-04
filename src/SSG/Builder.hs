{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE NoMonoLocalBinds #-}
{-# OPTIONS_GHC -Wno-simplifiable-class-constraints #-}

module SSG.Builder where

import Control.Lens (Lens', view, (%~))
import Data.Generic.HKD
import SSG.Assignments (Assignments (..))
import qualified SSG.Assignments as Assignments
import SSG.Container (Container (..))
import SSG.Fallback
import SSG.Result
import Prelude

type Field = Fallback Assignments

type Partial a = HKD a Field

type Update a = Partial a -> Partial a

type Builder a = Update a -> Result' a

type LabelExtractor a = (forall b. Field b -> Bool) -> Partial a -> [String]

builder :: forall a. (Monoid (Partial a), FunctorB (HKD a), Construct Maybe a) => LabelExtractor a -> Builder a
builder labels updates =
  let initial :: Partial a
      initial = mempty
      values = updates initial
      missing = labels isEmpty values
      repeatedDefaults = labels (Assignments.isMany . view _default) values
      repeatedExplicits = labels (Assignments.isMany . view _explicit) values
      warnings =
        map ("Default set more than once: " <>) repeatedDefaults
          <> map ("Field set more than once: " <>) repeatedExplicits

      resolved :: HKD a Maybe
      resolved = bmap valueOf values
   in case construct resolved of
        Just result -> Success warnings result
        Nothing -> Failed (map ("Missing field: " <>) missing) warnings

set :: Lens' (HKD structure Field) (Field a) -> a -> HKD structure Field -> HKD structure Field
set lens value u = u & lens %~ (_explicit %~ (<> Once value))

setDefault :: Lens' (HKD structure Field) (Field a) -> a -> HKD structure Field -> HKD structure Field
setDefault lens value u = u & lens %~ (_default %~ (<> Once value))

noDefaults :: Update a
noDefaults = id
