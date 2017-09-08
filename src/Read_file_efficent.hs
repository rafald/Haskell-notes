#!/usr/bin/env stack
-- stack script --resolver=ghc-8.2.1 

{-# LANGUAGE BangPatterns #-}
module Read_file_efficent where

import qualified Data.ByteString as B
import qualified System.IO as IO
-- http://www.fpcomplete.com/blog/2017/06/understanding-resourcet
main :: IO ()
main = do
  len <- myFileLength "/usr/share/dict/words"
  print len

-- Yes, there's hFileSize... ignore that
myFileLength :: FilePath -> IO Int
myFileLength fp = IO.withBinaryFile fp IO.ReadMode $ \h ->
  let loop !total = do
        next <- B.hGetSome h 4096
        if B.null next
          then return total
          else loop $ total + B.length next
   in loop 0
