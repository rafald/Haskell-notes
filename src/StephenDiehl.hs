#!/usr/bin/env stack
-- stack --resolver=ghc-8.2.1 runghc 

{-# LANGUAGE TypeOperators ,PolyKinds ,TypeSynonymInstances ,ConstraintKinds 
    ,MultiParamTypeClasses ,FlexibleInstances ,GADTs ,UndecidableInstances 
    ,AllowAmbiguousTypes #-} 
-- KindSignatures TypeFamilies
module StephenDiehl where

--{-# LANGUAGE NoImplicitPrelude #-}
import Prelude hiding (Functor,fmap,(.))
import GHC.Exts (Constraint)
--import ConstraintKinds(Constraint)

-- Morphisms
type (a ~> b) c = c a b

class Category (c :: k -> k -> *) where
  id :: (a ~> a) c
  (.) :: (y ~> z) c -> (x ~> y) c -> (x ~> z) c


--In Haskell we call this category Hask, over the type constructor (->) of function types between Haskell types.
type Hask = (->)

instance Category Hask where
  id x = x
  (f . g) x = f (g x)


class (Category c, Category d) => Functor c d t where
  --fmap :: (a ~> b) c -> ((t a) ~> (t b)) d 
  fmap :: c a b -> d (t a) (t b)
-- with laws:
--  fmap id ≡ id
--  fmap (a . b) ≡ (fmap a) . (fmap b)



--The identity functor 1C1C for a category CC is a functor mapping all objects to themselves and all morphisms to themselves.
newtype Id a = Id a

instance Functor Hask Hask Id where
  fmap f (Id a) = Id (f a)

instance Functor Hask Hask [] where
  fmap f [] = []
  fmap f (x:xs) = f x : (fmap f xs)

instance Functor Hask Hask Maybe where
  fmap f Nothing = Nothing
  fmap f (Just x) = Just (f x)
--An endofunctor is a functor from a category to itself, i.e. (T:C→C).
type Endofunctor c t = Functor c c t


-- The composition of two functors is itself a functor as well. Convincing Haskell of this fact requires some trickery with constraint kinds and scoped type variables.
--newtype FComp g f x = C { unC :: g (f x) }
--newtype Hom (c :: * -> Constraint) a b = Hom (a -> b)
-- TODO ??? c ~ Hom k
--instance (Functor a b f, Functor b c g, c ~ Hom k) => Functor a c (FComp g f) where
--  fmap f = (Hom C) . (fmapg (fmapf f) . (Hom unC))
--    where
--      fmapf = fmap :: a x y -> b (f x) (f y)
--      fmapg = fmap :: b s t -> c (g s) (g t)



main = print "Hello World!"

