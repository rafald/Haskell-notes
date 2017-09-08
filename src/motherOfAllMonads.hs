#!/usr/bin/env stack
-- stack runghc motherOfAllMonads.hs
module MotherOfAllMonads where

import Control.Monad.Cont

ex1 :: Cont Int ()
ex1 = do
  a <- cont( const 1 )
  b <- cont ( \fred -> fred (10 :: Int) )
  --b <- return $ cont ( \fred -> fred 10 )
  return $ a + b

main = putStr $ runCont ex1 show
