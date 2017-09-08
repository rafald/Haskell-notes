#!/usr/bin/env stack
-- stack runghc
-- stack --resolver=ghc-8.2.1 runghc
{-# LANGUAGE RankNTypes #-}
module ContVoidAbsurd where

import Control.Monad.Cont
import Control.Monad
import Data.Void

-- hole -> next hole
firstStep :: () -> ContT () IO Integer
firstStep _ = ContT $ \k -> do print "from firstStep function"
                               k 7

done :: Integer -> ContT () IO ()
done i = ContT $ \kUnused -> do liftIO $ print "from done function, expecting integer as input"
                             --liftIO $ print (show i)
                        

run :: (Monad m) => ContT r m Void -> m r
run c = runContT c absurd

main = do
       let prg0 = firstStep >=> done
       let execUntil = prg0 ()
       --let prg = done
       runContT execUntil (\_ -> putStr "DUPA")
       --runContT prg (\_ -> return "DUPA" )
       runContT execUntil (\_ -> return () )
