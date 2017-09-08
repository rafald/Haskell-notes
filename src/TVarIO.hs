#!/usr/bin/env stack
-- stack script --resolver=ghc-8.2.1 

{-# LANGUAGE FlexibleContexts #-}
module TVarIO where

import Control.Concurrent.Async.Lifted.Safe
import Control.Monad.Reader
import Control.Concurrent.STM
import Say

data Env = Env
  { envLog :: !(String -> IO ())
  , envBalance :: !(TVar Int)
  }

modify :: (MonadReader Env m, MonadIO m)
       => (Int -> Int)
       -> m ()
modify f = do
  env <- ask
  liftIO $ atomically $ modifyTVar' (envBalance env) f

logSomething :: (MonadReader Env m, MonadIO m)
             => String
             -> m ()
logSomething msg = do
  env <- ask
  liftIO $ envLog env msg

main :: IO ()
main = do
  ref <- newTVarIO 4
  let env = Env
        { envLog = sayString
        , envBalance = ref
        }
  runReaderT
    (concurrently
      (modify (+ 1))
      (logSomething "Increasing account balance"))
    env
  balance <- readTVarIO ref
  sayString $ "Final balance: " ++ show balance
