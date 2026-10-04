module SSG.Result where

data Result error warning a
  = Failed error warning
  | Success warning a
  deriving (Show)

instance Functor (Result error warning) where
  fmap _ (Failed errors warnings) = Failed errors warnings
  fmap f (Success warnings value) = Success warnings (f value)

instance (Semigroup error, Monoid warning) => Applicative (Result error warning) where
  pure = Success mempty

  Failed errors warnings <*> Failed moreErrors moreWarnings =
    Failed (errors <> moreErrors) (warnings <> moreWarnings)
  Failed errors warnings <*> Success moreWarnings _ =
    Failed errors (warnings <> moreWarnings)
  Success warnings _ <*> Failed errors moreWarnings =
    Failed errors (warnings <> moreWarnings)
  Success warnings f <*> Success moreWarnings value =
    Success (warnings <> moreWarnings) (f value)

type Result' = Result [String] [String]
