#!/usr/bin/env stack
-- stack script --resolver=ghc-8.2.1 
-- stack exec ghc -- -O2 -threaded 
module Compiled_stack_script where
--package turtle
-- lts-7.9 

--6.24
-- `-O2` turns on all optimizations
-- `-threaded` helps with piping shell output in and out of Haskell

main = do 
  putStrLn "Hello World!"
  putStrLn "Hi!"

