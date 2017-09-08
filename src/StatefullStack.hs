#!/usr/bin/env stack
-- stack script --resolver=ghc-8.2.1 
-- stack runghc --install-ghc
module StatefullStack where

import Control.Monad.State

type Stack = [Int]
  
push :: Int -> State Stack ()  
push a = state $ \xs -> ((),a:xs)

pop :: State Stack Int  
pop = state $ \(x:xs) -> (x,xs)  

stackManip :: State Stack Int  
stackManip = do  
    push 3  
    a <- pop  
    pop 


stackStuff :: State Stack ()  
stackStuff = do  
    a <- pop  
    if a == 5  
        then push 5  
        else do  
            push 3  
            push 8 


moreStack :: State Stack ()  
moreStack = do  
    a <- stackManip  
    if a == 100  
        then stackStuff  
        else return ()  
        
stackyStack :: State Stack ()  
stackyStack = do  
    stackNow <- get  
    if stackNow == [1,2,3]  
        then put [8,3,1]  
        else put [9,2,1] 


------------------------------------------------------------------------
tick :: State Int Int
tick = do 
    n <- get
    put (n+1)
    return n

plusOne :: Int -> Int
plusOne n = execState tick n
 
testTick :: State Int Int
testTick = do
    c <- get 
    put 7
    tick
    tick
    c <-get -- SAME ID !!!!!!!!
    c <-get 
    tick
    
------------------------------------------------------------------------                                       
main :: IO ()
main = do
   print $ runState testTick 3 -- (9,10)
   let c2 = runState tick 3
   print $ fst c2 -- 3
   print $ runState stackManip [5,8,2,1] -- (5,[8,2,1])
   print $ runState stackStuff [9,0,2,1,0]  -- ((),[8,3,0,2,1,0])
   print $ runState stackyStack [9,0,2,1,0] -- ((),[9,2,1])
   let c3 = runState tick $ snd c2
   print $ fst c3 -- 4
