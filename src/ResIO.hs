#!/usr/bin/env stack
-- stack script --resolver=ghc-8.2.1 

{-# LANGUAGE BangPatterns #-}
module ResIO where

import qualified Data.ByteString as B
import qualified System.IO as SIO
import Data.Word (Word8)
import Control.Monad.Trans.Resource --ResourceIO
import Control.Monad.IO.Class

data ListT m a
  = ConsT a (m (ListT m a))
  | NilT

sourceHandle :: MonadIO m => SIO.Handle -> m (ListT m B.ByteString)
sourceHandle h = liftIO $ do
  next <- B.hGetSome h 4096
  if B.null next
    then do
      SIO.hClose h
      return NilT
    else return $ ConsT next (sourceHandle h)

type ResourceIO = ResourceT IO
sourceFile :: FilePath -> ResourceIO (ListT ResourceIO B.ByteString)
sourceFile fp = do
  h <- liftIO $ SIO.openBinaryFile fp SIO.ReadMode
  sourceHandle h

firstByte :: Monad m => m (ListT m B.ByteString) -> m (Maybe Word8)
firstByte mnext = do
  next <- mnext
  return $
    case next of
      ConsT bs _mnext' -> Just $ B.head bs
      NilT             -> Nothing

main :: IO ()
main = do
  mbyte <- runResourceT $ firstByte $ sourceFile "/usr/share/dict/words"
  --mbyte <- runResourceIO $ firstByte $ sourceFile "/usr/share/dict/words"
  print mbyte
