#!/usr/bin/env stack
-- stack script --resolver=ghc-8.2.1
-- --resolver=lts-9.4

module LoopState where 
-- https://www.reddit.com/r/haskell/comments/3hfdmn/understanding_the_state_monad/

import Control.Monad
import Control.Monad.State.Strict
main = runStateT (forever go) []
  where go = do line <- lift getLine
                modify (line :)
                state <- get
                lift (print state)

