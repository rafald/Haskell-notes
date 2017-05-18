#!/usr/bin/env stack
-- stack runghc --resolver lts-8.0 --install-ghc

-- http://www.serpentine.com/criterion/
import Criterion.Main

fib :: (Num t, Num a, Ord a) => a -> t
fib m | m < 0     = error "negative!"
      | otherwise = go m
  where go 0 = 0
        go 1 = 1
        go n = go (n-1) + go (n-2)

main :: IO ()
main = defaultMain [
  bgroup "fib" [ bench "1"  $ whnf fib 1
               , bench "5"  $ whnf fib 5
               , bench "11" $ whnf fib 11
               ]
  ]
