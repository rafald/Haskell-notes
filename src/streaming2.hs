#!/usr/bin/env stack
-- stack --resolver lts-9.4 exec ghc --package conduit-combinators -- -O2
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE BangPatterns #-}

--module Streaming2 where

import Conduit
import Control.DeepSeq -- import Control.DeepSeq (force)
import GHC.Generics (Generic)

--average :: Monad m => ConduitM (RunningTotal Int Int) o m Double
average :: Monad m => ConduitM Int o m Double
average =
  divide <$> foldlC add (RunningTotal 0 0) -- TODO why $ RunningTotal 0 0    did not work ??????
  where
    divide (RunningTotal total count) = fromIntegral total / fromIntegral count
    add (RunningTotal total count) x = RunningTotal (total + x) (count + 1) -- force $ does not improve

main :: IO ()
main = print $ runConduitPure $ enumFromToC 1 (50*1000000) .| average

--EXERCISE Make this program run in constant resident memory, by using:

--The force function
--Bang patterns
--A custom data type with strict fields

data RunningTotal = RunningTotal
  { count :: !Int
  , sum :: !Int
  }
  deriving Generic

instance NFData RunningTotal
