{-# LANGUAGE ExistentialQuantification ,TypeOperators #-}
module TypeOperators where

--Illegal declaration of a type or class operator ‘:*’
--          Use TypeOperators to declare operators in type and declarations
data a :* b = forall i . P (a i) (b i)

