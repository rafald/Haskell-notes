#!/usr/bin/env stack
-- stack --resolver lts-9.4 exec ghc
-- stack --resolver lts-9.4 exec ghc MemUsage.hs && ./MemUsage "+RTS" -s
-- +RTS -s
{-# LANGUAGE DeriveGeneric #-}
module MemUsage2 where

import GHC.Generics (Generic)
import Control.DeepSeq

printAverage :: RunningTotal -> IO ()
printAverage (RunningTotal sum count)
  | count == 0 = error "Need at least one value!"
  | otherwise = print (fromIntegral sum / fromIntegral count :: Double)

-- | A fold would be nicer... we'll see that later
printListAverage :: [Int] -> IO ()
printListAverage =
  go (RunningTotal 0 0)
  where
    go rt [] = printAverage rt
    go (RunningTotal sum count) (x:xs) =
      let rt = RunningTotal (sum + x) (count + 1)
       in rt `deepseq`         go rt xs

main :: IO ()
main = printListAverage [1..1000000]



data RunningTotal = RunningTotal
  { sum :: Int
  , count :: Int
  }
  deriving Generic
instance NFData RunningTotal

