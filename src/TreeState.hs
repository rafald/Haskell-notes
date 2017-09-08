#!/usr/bin/env stack
-- stack script --resolver=ghc-8.2.1 
-- stack runghc --install-ghc
module TreeState where

import Control.Monad.Trans.State
import Data.List

data Tree a = Nil | Node a (Tree a) (Tree a) deriving (Show, Eq)
type Table a = [a] -- this is the mutable STATE
numberTree :: Eq a => Tree a -> State (Table a) (Tree Int) -- State stateToCarry returnValue
numberTree Nil = return Nil
numberTree (Node x t1 t2) = do
    num <- numberNode x
    nt1 <- numberTree t1
    nt2 <- numberTree t2
    return (Node num nt1 nt2)
  where
    numberNode :: Eq a => a -> State (Table a) Int
    numberNode x = do
        table <- get
        case elemIndex x table of
            Nothing -> do
                put (table ++ [x])
                return (length table)
            Just i -> return i

numTree :: (Eq a) => Tree a -> Tree Int
numTree t = evalState (numberTree t) [] -- return the final value, discarding the final state
-- initial state is []


testTree = Node "Zero" (Node "One" (Node "Two" Nil Nil) (Node "One" (Node "Zero" Nil Nil) Nil)) Nil
main = do
  print $ numTree testTree  
  print $ execState (numberTree testTree) [] -- reurn the final state, discarding the final value.
-- numTree testTree => Node 0 (Node 1 (Node 2 Nil Nil) (Node 1 (Node 0 Nil Nil) Nil)) Nil

