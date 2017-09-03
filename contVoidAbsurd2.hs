#!/usr/bin/env stack
-- stack runghc
-- stack --resolver=ghc-8.2.1 runghc
{-# LANGUAGE RankNTypes #-}

import Control.Monad.Cont
import Control.Monad
import Data.Void


data Hole = Swing Int | Attack String | Move Int Int Int

-- result of continuation is Char !!! not ()
largeProgram :: () -> ContT () IO Hole
largeProgram () = ContT $ \k -> do -- do ??? what is the monad 
    x <- k (Swing 123)
    print x -- prints ()
    k (Attack "Bum!")
    k (Move  2 3 5)

data BobsHole = ResponseToAttack String
bobsWork :: Hole -> ContT () IO BobsHole
bobsWork hole = ContT $ \k -> case hole of
                        Swing i -> print "Swing handling"
                        Attack s -> do print "Attack handling"
                                       k (ResponseToAttack s)
                        Move x y z -> print "Move handling"


lastStep :: BobsHole -> ContT () IO a -- TODO try to use Void
lastStep hole = ContT $ \_ -> case hole of
                        ResponseToAttack s -> print "I will respond strongly"


main = do print "Hello World!"
          let prg = largeProgram >=> bobsWork >=> lastStep
          runContT (prg ()) (\_ -> putStr "DUPA")
          runContT (prg ()) absurd
          print "Done."
