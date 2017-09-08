#!/usr/bin/env stack
-- stack script --resolver=ghc-8.2.1
module ConduitTest where


import Conduit

main :: IO ()
main = do
  len <- runResourceT
       $ runConduit
       $ sourceFile "/usr/share/dict/words"
      .| lengthCE
  print len
