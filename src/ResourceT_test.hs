#!/usr/bin/env stack
-- stack runghc --resolver=ghc-8.2.1 --package enumerator --package text
module ResourceT_test where

import System.IO
import Control.Monad

import Data.Enumerator
import Data.Enumerator.Binary

main = do
   output <- openFile "#1#ResourceT_test.hs" WriteMode
   input  <- openFile "ResourceT_test.hs"  ReadMode
   hGetContents input >>= hPutStr output
   hClose input
   hClose output
   withFile "#2#ResourceT_test.hs" WriteMode $ \output ->
                                                withFile "#1#ResourceT_test.hs" ReadMode $ hGetContents >=> hPutStr output
   let x = 2 + 4
   withFile "output.txt" WriteMode $ \output -> run_ $ enumFile "input.txt" $$ iterHandle output
   print "files copied, exit 0"
