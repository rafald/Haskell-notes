#!/usr/bin/env stack
-- stack script --resolver=ghc-8.2.1 
-- stack --verbosity info runghc --install-ghc 
module State_mondad_with_IO where

import Control.Monad.State
 
main :: IO ()
main = runStateT code [1..] >> return ()
--
-- layer an infinite list of uniques over the IO monad
--
 
code :: StateT [Integer] IO ()
code = do
    x <- pop
    io $ print x
    push 27
    y <- pop
    liftIO $ print y
    z <- pop
    io $ print z
    return ()
 
--
-- pop the next unique off the stack
--
pop :: StateT [Integer] IO Integer
pop = do
    (x:xs) <- get
    put xs
    return x

-- RLD
push :: Integer -> StateT [Integer] IO ()
push x = do
    xs <- get
    put $ x:xs
    return ()
 
io :: IO a -> StateT [Integer] IO a
io = liftIO
