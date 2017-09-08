{-# LANGUAGE GADTs #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeInType #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE RankNTypes #-}
module UI_Sketch where

import Data.Proxy
import Data.Kind

newtype Username = Username String
newtype Password = Password String
newtype CommandString = CommandString String

data Page where
    LoginPage :: Page
    MainPage :: Page
    HelpPage :: Page

type family UserInput (page :: Page) :: Type where
    UserInput 'LoginPage = (Username, Password)
    UserInput 'MainPage = CommandString
    UserInput 'HelpPage = ()

data Transition (from :: Page) (to :: Page) where

    LoginTransition :: Transition 'LoginPage 'MainPage

    MainTransitionLogout :: Transition 'MainPage 'LoginPage
    MainTransitionHelp :: Transition 'MainPage 'HelpPage

    HelpTransitionQuit :: Transition 'HelpPage 'MainPage

data TransitionFrom (from :: Page) where
    TransitionFrom :: Transition from to -> TransitionFrom from

data TransitionTo (to :: Page) where
    TransitionTo :: Transition from to -> TransitionTo to

-- The singleton motif on Page. Pattern matching on this GADT will reveal
-- the promoted data constructor kind of the corresponding page, allowing us
-- to use it in the UserInput and Transition families.
data Storyboard (page :: Page) where
    Login :: Storyboard 'LoginPage
    Main :: Storyboard 'MainPage
    Help :: Storyboard 'HelpPage

newtype Controller appF page = Controller {
      unController ::
              Storyboard page
           -> UserInput page
           -> appF (Either (Controller appF page) (NextController appF page))
    }

data NextController appF page where
    NextController :: Transition from to -> Controller appF to -> NextController appF from

controllerLogin :: Controller IO 'LoginPage
controllerLogin = Controller $ \page -> case page of
    Login -> \(username, password) -> pure (Right (NextController LoginTransition controllerMain))

controllerMain :: Controller IO 'MainPage
controllerMain = Controller $ \page -> case page of
    Main -> \(CommandString str) -> case str of
        "seeya" -> pure (Right (NextController MainTransitionLogout controllerLogin))
        "help me" -> pure (Right (NextController MainTransitionHelp controllerHelp))
        _ -> pure (Left controllerMain)

controllerHelp :: Controller IO 'HelpPage
controllerHelp = Controller $ \page -> case page of
    Help -> \() -> pure (Right (NextController HelpTransitionQuit controllerMain))
