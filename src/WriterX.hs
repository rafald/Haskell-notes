
-- http://stackoverflow.com/questions/11684321/how-to-play-with-control-monad-writer-in-haskell
{-# LANGUAGE FlexibleContexts #-}

module WriterX where

import Control.Monad.Writer
logNumber x = writer (x, ["Got number: " ++ show x])
test = runWriter multWithLog
   where
      multWithLog = do { a <- logNumber 3; b <- logNumber 5; return (a*b) } :: Writer [String] Int
