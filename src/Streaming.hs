#!/usr/bin/env stack
-- stack --resolver lts-9.4 exec ghc --package conduit-combinators -- -O2
module Streaming where

import Conduit

average :: Monad m => ConduitM Int o m Double
average =
  divide <$> foldlC add (0, 0)
  where
    divide (total, count) = fromIntegral total / count
    add (total, count) x = (total + x, count + 1)

main :: IO ()
main = print $ runConduitPure $ enumFromToC 1 1000000 .| average

