module Website.Site where

data Site = Site
  { title :: String -> String,
    description :: String,
    keywords :: [String]
  }

site :: Site
site =
  Site
    { title = (<> " | Todo"),
      description = "An Overengineered Todo App",
      keywords = ["todo", "list"]
    }
