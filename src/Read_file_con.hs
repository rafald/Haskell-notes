#!/usr/bin/env stack
-- stack script --resolver=ghc-8.2.1

--{-# LANGUAGE BangPatterns #-}
module Read_file_con where

import qualified Data.ByteString as B
import           Data.Word       (Word8)
import qualified System.IO       as IO

data IOSource a
  = IOChunk a (IO (IOSource a))
  | IODone

sourceHandle :: IO.Handle -> IO (IOSource B.ByteString)
sourceHandle h = do
  next <- B.hGetSome h 4096
  if B.null next
    then do
      putStrLn "Closing file handle"
      IO.hClose h
      return IODone
    else return $ IOChunk next (sourceHandle h)

sourceFile :: FilePath -> IO (IOSource B.ByteString)
sourceFile fp = do
  h <- IO.openBinaryFile fp IO.ReadMode
  sourceHandle h

firstByte :: IO (IOSource B.ByteString) -> IO (Maybe Word8)
firstByte mnext = do
  next <- mnext
  return $
    case next of
      IOChunk bs _mnext' -> Just $ B.head bs
      IODone             -> Nothing

--  mbyte <- firstByte $ sourceFile "/usr/share/dict/words"
--  print mbyte
main :: IO ()
main = do
  mbyte <- IO.withBinaryFile "/usr/share/dict/words" IO.ReadMode
         $ \h -> firstByte $ sourceHandle h
  print mbyte
  fb <- firstByte $ sourceFile "/usr/share/dict/words"
  print fb -- mbyte fb
