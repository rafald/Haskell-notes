#!/usr/bin/env stack
-- stack script --resolver=ghc-8.2.1 
module Read_file where

import qualified Data.ByteString as B
import qualified System.IO as IO

main :: IO ()
main = do
  bs <- myReadFile "/usr/share/dict/words"
  print $ B.length bs

myReadFile :: FilePath -> IO B.ByteString
myReadFile fp = IO.withBinaryFile fp IO.ReadMode $ \h ->
  -- Highly inefficient, use a builder instead
  let loop front = do
        next <- B.hGetSome h 4096
        if B.null next
          then return front
          else loop $ B.append front next
   in loop B.empty
