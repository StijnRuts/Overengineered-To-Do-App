module Website.Site where

data SiteParams = SiteParams
  { siteTitle :: String,
    siteDescription :: String,
    siteKeywords :: String
  }

siteParams :: SiteParams
siteParams =
  SiteParams
    { siteTitle = "Todo",
      siteDescription = "An Overengineered Todo App",
      siteKeywords = "todo list"
    }
