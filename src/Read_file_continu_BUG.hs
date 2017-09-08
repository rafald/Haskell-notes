#!/usr/bin/env stack
-- stack script --resolver=ghc-8.2.1 

{-# LANGUAGE BangPatterns #-}
module Read_file_continu_BUG where

import qualified Data.ByteString as B
import qualified System.IO as IO

data IOSource a
  = IOChunk a (IO (IOSource a))
  | IODone

sourceHandle :: IO.Handle -> IO (IOSource B.ByteString)
sourceHandle h = do
  next <- B.hGetSome h 4096
  return $
    if B.null next
      then IODone
      else IOChunk next (sourceHandle h)

sourceFile :: FilePath -> IO (IOSource B.ByteString)
sourceFile fp = IO.withBinaryFile fp IO.ReadMode sourceHandle

sourceLength :: IO (IOSource B.ByteString) -> IO Int
sourceLength =
    loop 0
  where
    loop !total mnext = do
      next <- mnext
      case next of
        IOChunk bs mnext' -> loop (total + B.length bs) mnext'
        IODone -> return total

main :: IO ()
main = do
  len <- sourceLength $ sourceFile "/usr/share/dict/words"
  print len
