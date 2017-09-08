#!/usr/bin/env stack
-- stack script --resolver=ghc-8.2.1 

{-# LANGUAGE FlexibleContexts #-}
module TVar where

import Control.Concurrent.Async.Lifted.Safe
import Control.Monad.Reader
import Control.Concurrent.STM

modify :: (MonadReader (TVar Int) m, MonadIO m)
       => (Int -> Int)
       -> m ()
modify f = do
  ref <- ask
  liftIO $ atomically $ modifyTVar' ref f

main :: IO ()
main = do
  ref <- newTVarIO 4
  runReaderT (concurrently (modify (+ 1)) (modify (+ 2))) ref
  readTVarIO ref >>= print
