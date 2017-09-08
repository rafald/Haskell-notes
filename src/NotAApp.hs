#!/usr/bin/env stack
-- stack script --resolver=ghc-8.2.1

{-# LANGUAGE ExistentialQuantification ,StandaloneDeriving #-}
module NotAApp where

import Control.Monad

data AFunctor a = forall f . Functor f => AFunctor { unFunct :: f a } -- deriving ( Show )
--deriving instance Show a => Show (AFunctor a)
instance Functor AFunctor where
   fmap t (AFunctor x) = AFunctor ( fmap t x )
   
data AFunctor2 f a = AFunctor2 { unFunct2 :: f a } --deriving Functor

e = AFunctor [2 :: Integer, 5]
te = fmap (*3) e
--e2 = AFunctor2 [2, 5]
--ue2 = unFunct2 e2

--extract unFunct x = x

--printF x :: foreach f. Functor f => print 

main = do print "HW" --print AFunctor [2, 5]
          --join $ fmap (print) e 
          --print $ unFunct2 e2 
