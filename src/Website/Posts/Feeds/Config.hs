module Website.Posts.Feeds.Config where

data FeedConfiguration = FeedConfiguration
  { feedTitle :: String,
    feedDescription :: String,
    feedAuthorName :: String,
    feedAuthorEmail :: String,
    feedRoot :: String
  }

feedConfiguration :: FeedConfiguration
feedConfiguration =
  FeedConfiguration
    { feedTitle = "Todo App",
      feedDescription = "An overengineered todo app",
      feedAuthorName = "Stijn Ruts",
      feedAuthorEmail = "stijn@example.com",
      feedRoot = "http://todo.example.com"
    }
