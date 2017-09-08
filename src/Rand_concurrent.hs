#!/usr/bin/env stack
-- stack script --resolver=ghc-8.2.1 
module Rand_concurrent where

import Control.Concurrent.Async.Lifted
import Control.Monad.State.Strict

main :: IO ()
main = execStateT
    (concurrently (modify (+ 1)) (modify (+ 2)))
    4 >>= print


