#!/usr/bin/env stack
-- stack runghc --install-ghc --package turtle
module Stack_script where
-- lts-7.9 

--6.24
-- `-O2` turns on all optimizations
-- `-threaded` helps with piping shell output in and out of Haskell

main = do 
  putStrLn "Hello World!"
  putStrLn "Hi!"

