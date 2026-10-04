module Website.Navigation.Navigation where

import Text.Blaze.Html5 (Html, (!))
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

headerNavigationHtml :: Html
headerNavigationHtml =
  H.ul $ do
    H.li $ H.a ! A.href "/" $ "Home"
    H.li $ H.a ! A.href "/about" $ "About"
    H.li $ H.a ! A.href "/blog" $ "Blog"

footerNavigationHtml :: Html
footerNavigationHtml = H.ul $ do
  H.li $ H.a ! A.href "/policy/disclaimer" $ "Disclaimer"
  H.li $ H.a ! A.href "/policy/privacy" $ "Privacy Policy"
  H.li $ H.a ! A.href "/policy/cookies" $ "Cookies Policy"
