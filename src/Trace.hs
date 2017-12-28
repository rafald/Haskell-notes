#!/usr/bin/env stack
-- stack --resolver lts-9.4 script
module Trace where 

import Debug.Trace

add :: Int -> Int -> Int
add x y = x + y

main :: IO ()
main = do
  let five = trace "five" (add (1 + 1) (1 + 2))
      seven = trace "seven" (add (1 + 2) (1 + 3))

  putStrLn $ "Five: " ++ show five
