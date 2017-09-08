#!/usr/bin/env stack
-- stack script --resolver=ghc-8.2.1 
-- stack runghc --install-ghc 
{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE RankNTypes                #-}
--{-# LANGUAGE DataKinds #-}
--{-# LANGUAGE TypeInType #-}
{-# LANGUAGE PartialTypeSignatures     #-}
module Exists where

-- forall is intersection
--map :: forall a b. (a -> b) -> [a] -> [b]
--id :: forall a . a -> a
-- exist is union

data T = forall a. MkT a -- a could be anything
--data T = MkT (exists a. a)
--MkT :: (exists a. a) -> T
heteroList :: [T]
heteroList = [MkT (5 :: Int) , MkT (), MkT True, MkT "Sartre"]

foo :: T -> IO ()
foo (MkT _x) = print "x dowolnego typu" -- what is the type of x?
-- _x :: exists a. a

-- T' is a box for some types
-- a is union of types which have Show
data T' = forall a. Show a => MkT' a
-- Which is isomorphic to:
-- Example: The new datatype, translated into 'true' existential types
-- data T' = MkT' (exists a. Show a => a)
-- http://stackoverflow.com/questions/5235116/what-does-exists-mean-in-haskell-type-system
--unwrapT' :: exists a. Show a => MkT' a -> a
--unwrapT' :: T' -> forall a. Show a => a
--unwrapT' :: forall a. Show a => T' -> a
--unwrapT' (MkT' x) = x

--Again the class constraint serves to limit the types we're unioning over, so that now we know the values inside a MkT' are elements of some arbitrary type which instantiates Show. The implication of this is that we can apply show to a value of type exists a. Show a => a. It doesn't matter exactly which type it turns out to be.
--Example: Using our new heterogenous setup

heteroList' :: [T']
heteroList' = [MkT' (5 :: Int) , MkT' (), MkT' True, MkT' "Sartre"]



data Baz = forall a. Eq a => Baz1 a a
         | forall b. Show b => Baz2 b (b -> b)
         | forall b . (Eq b , Show b) => Baz3 b b (b -> b)
--The two constructors have the types you'd expect:
--Baz1 :: forall a. Eq a => a -> a -> Baz
--Baz2 :: forall b. Show b => b -> (b -> b) -> Baz
f :: Baz -> String
f (Baz1 p q) | p == q    = "Yes"
              | otherwise = "No"
f (Baz2 v fn)            = show (fn v)
f (Baz3 v v2 fn)            = show (v == v2) ++ show (fn v) ++ show (fn v2)



main :: IO ()
--main = mapM_ (\(MkT' x) -> print x) heteroList'
main = do
  print . f $ Baz1 True False
  print . f $ Baz2 (5.3 :: Double) (\x -> 2*x )
  print . f $ Baz3 (5.3 :: Double) (5.3 :: Double) (\x -> 2*x )
  print . f $ Baz3 (5.3 :: Double) (4.3 :: Double) (\x -> 2*x )
  mapM_ (\(MkT x) -> foo (MkT x) ) heteroList
  mapM_ (\(MkT' x) -> print x) heteroList'

-- 5
-- ()
-- True
-- "Sartre"
