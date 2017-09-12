#!/usr/bin/env stack
-- stack --verbosity info script --install-ghc --resolver=ghc-8.2.1
-- --resolver=lts-9.4
-- --resolver nightly-2017-07-11

module Reader_Hspec_discover where -- NOT must be before following {-# OPTIONS_GHC ...
{-# OPTIONS_GHC -F -pgmF hspec-discover #-}
-- Failed to load interface for ‘Test.Hspec.Discover’
--    It is a member of the hidden package ‘hspec-2.4.4’.

import Control.Monad.Instances  

-- reader monad allows us to treat functions as values with a context.
-- if we have a lot of functions that are all just missing one parameter and they'd eventually be applied to the same thing, 
-- we can use the reader monad to sort of extract their __future results__ ( a <- or b <- ) and the >>= implementation will make sure that it all works out.
  
addStuff :: Int -> Int  
addStuff = do  
    a <- (*2)  
    b <- (+10)  
    return (a+b) -- normal addition of regular Ints

xaddStuff :: Int -> Int  
xaddStuff x = let  
    a = (*2) x  
    b = (+10) x  
    in a+b 

cStuff :: Int -> Int  
cStuff = do
    a <- (*2)  
    b <- (+a) -- not possible with applicative
    return (a+b)  

main = do
   print $ cStuff 3
   print $ addStuff 3
   let f = (+) <$> (*2) <*> (+10)
   print $ f 3
   let g = (*) <$> (*2) <*> (+10)
   print $ g 3
   --let h = (.) <$> (*2) <*> (+10)
   --print $ h 3
