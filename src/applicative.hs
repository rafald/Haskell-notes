#!/usr/bin/env stack
-- stack script --resolver=ghc-8.2.1 
-- stack --verbosity info exec ghc --install-ghc
module Applicative where
{-# LANGUAGE FlexibleContexts, FlexibleInstances #-}
--{-# LANGUAGE NoImplicitPrelude #-}

--import qualified Data.Either()
-- https://stackoverflow.com/questions/23342184/difference-between-monad-and-applicative-in-haskell

newtype MyE a b = MyE { getE :: Either a b } deriving (Eq, Show)

instance Monoid e => Applicative (MyE e) where
  pure = MyE . Right
  (MyE (Right f)) <*> Right a = MyE . Right (f a)     -- neutral
  Left  e <*> Right _ = MyE . Left e          -- short-circuit
  Right _ <*> Left  e = MyE . Left e          -- short-circuit
  Left e1 <*> Left e2 = MyE . Left (e1 <> e2) -- combine!


main :: IO() -- Right (+1) <*>
--main = let x = Right (+) <*> Left [3] <*> Left [7] -- :: Either [Integer] Integer
main = let x = pure (+) <*> Left [3] <*> Left [7] -- :: Either [Integer] Integer
       in print x
