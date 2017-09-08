#!/usr/bin/env stack
-- stack script --resolver=ghc-8.2.1
-- --resolver=lts-9.0

-- ghci  -XNamedWildCards  -XPartialTypeSignatures test.hs
{-# LANGUAGE NamedWildCards #-}
{-# LANGUAGE PartialTypeSignatures #-}
module Type_wildcard where

f :: _x -> _x
-- f :: (Char, t) -> (Char, t)
f ('c', y) = ('d', error "Urk")
-- Inferred: forall t. (Char, t) -> (Char, t)
