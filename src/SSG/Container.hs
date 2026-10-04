module SSG.Container where

class Container f where
  valueOf :: f a -> Maybe a

  isEmpty :: f a -> Bool
  isEmpty container =
    case valueOf container of
      Nothing -> True
      Just _ -> False
