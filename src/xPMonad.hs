{-# LANGUAGE NoImplicitPrelude #-}

module PMonad where

import Prelude (fromInteger,(+),(*),show)
import Prelude (putStr,($))
--import Prelude (Monad)
--import Control.Monad

class PMonad m where
  return :: a -> m s s a
  (>>=) :: m s1 s a -> (a -> m s s2 b) -> m s1 s2 b
  (>>) :: m s1 s2 a -> m s2 s3 b -> m s1 s3 b
  fail :: m s1 s2 a

data XState s1 s2 a = XState { runXState :: s1 -> (a,s2) }
--instance Monad (XState s1 s2)

instance PMonad XState where
  return a = XState (\s ->(a,s))
  f >>= m = XState (\s1 ->
            case runXState f s1 of
              (a,s2) -> runXState (m a) s2)
  m1 >> m2 = m1 >>= \_ -> m2
  fail = fail

get = XState (\s -> (s,s))
put s = XState (\_ -> ((),s))

test1 = do x <- return 1 
           y <- return 2
           z <- get
           put (x+y*z)
           return z
go1 = runXState test1 10

test2 = do x <- return 1
           y <- return 2
           z <- get
           put (show (x+y*z))
           return z
go2 = runXState test2 10

main = putStr $ show go2
