#!/usr/bin/env stack
-- stack runghc
-- stack --resolver=ghc-8.2.1 runghc
{-# LANGUAGE RankNTypes #-}

import Control.Monad.Cont
import Control.Monad
import Data.Void
import Data.Char


data Hole = Swing Int | Attack String | Move Int Int Int | Trace | NotUsedEvent

-- result of continuation is Char !!! not ()
largeProgram :: () -> ContT Char IO Hole
largeProgram () = ContT $ \k -> ( do -- IO Char monad
    k (Swing 123)
    x <- k (Attack "Bum!") 
    putStrLn $ "LONGJUMP from k (Attack String) = " ++ show x -- printed () initially
    liftIO $ putStrLn "some trace" -- ??? what does here liftIO , already is IO monad
    k (Move  2 3 (ord x))
    k (Trace)
    return '0' ) :: IO Char
    

data BobsHole = ResponseToAttack String | BobsTrace
bobsWork :: Hole -> ContT Char IO BobsHole
bobsWork hole = ContT $ \k -> case hole of -- must return IO Char
                        Swing i -> do putStrLn "Swing handling"
                                      return 'S'
                        Attack s -> do putStrLn "Attack handling"
                                       k (ResponseToAttack s)
                        Move x y z -> do putStrLn "Move handling"
                                         return 'M'
                        Trace -> k(BobsTrace)


lastStep :: BobsHole -> ContT Char IO a -- TODO try to use Void
lastStep hole = ContT $ \k -> case hole of
                        ResponseToAttack s -> getChar -- putStrLn "I will respond strongly"
                        BobsTrace -> return 'B'


main = do print "Hello World!"
          let prg = largeProgram >=> bobsWork >=> lastStep
          result <- runContT (prg ()) absurd
          putStrLn $ "FINAL Result=" ++ show result
          runContT (prg ()) (\_ -> getChar) --runContT (prg ()) (\_ -> putStr "DUPA")
          print "Done."
