#!/usr/bin/env stack
-- stack --resolver lts-9.4 script
{-# LANGUAGE BangPatterns #-}
module Trace3 where

import Debug.Trace

add :: Int -> Int -> Int
add x y = x + y

main :: IO ()
main = do
  let five = trace "five" (add (1 + 1) (1 + 2))
  let seven = trace "seven" (add (1 + 2) (1 + 3))

  five `seq` seven `seq` putStrLn ("Five: " ++ show five)
