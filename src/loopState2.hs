#!/usr/bin/env stack
-- stack script --resolver=ghc-8.2.1
-- --resolver=lts-9.0
module LoopState2 where

import Control.Monad
import Control.Monad.State.Strict

main :: IO ()
main = runStateT 1 main'

main' :: StateT IO Int ()
main' = do line <- liftIO readLine
           if line == "exit" then liftIO $ putStrLn "Exiting. Have a good day."
           else do st <- get
                   put (st+1)
                   liftIO $ putStrLn $ "You entered: " ++ line
                   liftIO $ putStrLn $ "The loop has run " ++ show st ++ " times."

