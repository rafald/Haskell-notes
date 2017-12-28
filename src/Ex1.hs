#!/usr/bin/env stack
-- stack --resolver lts-9.4 script
module Ex1 where

import Control.Concurrent
import Control.Exception --(ErrorCall)


main = do
  tid <-  forkIO sleepyFn
  threadDelay 1
  throwTo  tid (ErrorCall "Abort")
  threadDelay 2
  
sleepyFn = do
  putStrLn "sleeping for 5 secs..." 
  threadDelay 3
  putStrLn "woke up!"

