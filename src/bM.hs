#!/usr/bin/env stack
-- stack script --resolver=ghc-8.2.1 
-- stack script --resolver=ghc-8.2.1
-- --resolver=lts-9.0

-- ghc
{-# LANGUAGE TypeOperators, RankNTypes, KindSignatures, ExistentialQuantification #-}
--    Illegal symbol '.' in type
--    Perhaps you intended to use RankNTypes or a similar language
--    extension to enable explicit-forall syntax: forall <tvs>. <type>
-- Data constructor ‘Coend’ has existential type variables, a context, or a specialised result type
--         Coend :: forall (p :: * -> * -> *) x. p x x -> Coend p
--         (Use ExistentialQuantification or GADTs to allow this)
module BM where

import qualified GHC.Base (id, (.))

import qualified Prelude(Monoid, ($))
import Prelude(Int)

-- Category ------------------------------------------------------------
class Category cat where
  id  :: a `cat` a
  (.) :: cat b c -> cat a b -> cat a c

-- regular functions (->)
instance Category (->) where
  id  = GHC.Base.id
  (.) = (GHC.Base..)


-- Monoid --------------------------------------------------------------
-- simpler version of category
class Monoid m where
   mu ::  (m, m) -> m -- cartesian product
   eta :: () -> m -- terminal obj, its a unit for (m, m) product - forming product of terminal obj and other obj does not change it - identity
   -- if we have product and terminal object => we can form Monoid
   -- generalized:   cartesian product -> tensor product,
   --                terminal obj -> some special obj, identity will respect ???

newtype IntFun = IF ( Int -> Int )
instance Monoid IntFun where
   mu ( IF f , IF g ) = IF ( g . f )
   eta () = IF id

-- Profunctor --------------------------------------------------------------
class Functor ( f :: * -> * ) where
   fmap :: ( a -> a') -> ( f a -> f a' )

class Bifunctor ( bf :: * -> * -> * ) where
   bimap :: ( a -> a') -> ( b -> b') -> ( bf a b -> bf a' b' )
-- instance is Pair Either

class Profunctor ( pf :: * -> * -> * ) where
   dimap :: ( a' -> a) -> ( b -> b') -> ( pf a b -> pf a' b' )
           -- ^ the only diffrence to bifunctor
instance Profunctor (->) where
    dimap con cov pf =  cov . pf . con

-- End --------------------------------------------------------------
type End p =  forall x. p x x -- can be defined for Profunctor (BM said Profunctor but later seems to say Bifunctor)
-- NOTE! forall is INFINITE PRODUCT !!!!! contains element of every possible x
-- following is an example of End
newtype NatPro f g a c = NatPro ( f a -> g c )
-- it is profunctorial in a and c
-- container of a -> container of b

instance ( Functor f , Functor g ) =>  Profunctor ( NatPro f g ) where
  dimap con_ba cov_cd (NatPro p) = NatPro Prelude.$ fmap cov_cd . p . fmap con_ba

type NatTransEnd f g = End (NatPro f g) -- inlined: type NatTrans2End f g = forall x. f x -> g x
-- repackahe container of xs into different container of xs
-- in Haskell diagram commute automatically, Theorems for free (because of parametricity)

-- dual to End is CoEnd infinite sum (coproduct)
-- type Coend p = exists x. p x x
-- easy to construct hard to deconstruct
data Coend p = forall x. Coend (p x x) -- x are existential - because of Coend() on the right side
                  -- ^ can call polymorphic constructor Coend()  with any type
-- trick forall x. comes before the name of the constructor
-- (exists x. C x) -> y ~ forall x. C x -> y
-- function must accept any x !!!
-- no idea what x is but I do not have to

-- Profunction as definition of relation between types a and b --------
-- every element of Profunctor a b is a proof




-- type Compose p q a b = exist x. (p a x, q x b) -- pair of proofs
data Compose p q a b = forall x. Compose (p a x)( q x b)
     -- ^ type constructor          ^ data constructor
-- operating on types, not values
-- looks like Profunctors operate like morphism, maybe some Category is sitting there


instance ( Profunctor p , Profunctor q ) =>  Profunctor ( Compose p q ) where
  dimap con cov (Compose pax qxb) = Compose ( dimap con id pax ) ( dimap id cov qxb )


-- Coend, first unglue to xs in exist x. (p a x, q x b), unglue to x and y (split x)
--data Compose p q a b = forall x. Compose (p a x)( q x b)
data TenProd p q a b x y = TenProd (p a y ) (q x b) -- becomes Profunctor (End is diagonal)
--type TenProd p q a b x y = (p a y ) (q x b)
-- tensor product
-- this is Profunctor in x and y !!!

instance ( Profunctor p , Profunctor q ) =>  Profunctor ( TenProd p q a b ) where
  dimap con cov (TenProd pay qxb) = TenProd ( dimap id cov pay ) ( dimap con id qxb )

-- Composition can be written as a Coend of this tensor product - alternate definition
--data Compose p q a b = Coend ( TenProd p q a b )

--- (Ninja) Yoneda Lemma -------------------------------------
newtype PreYoneda f a x y =
   PreYoneda ((a -> x) -> f y)
-- f functor, a fix type,

instance Functor f => Profunctor ( PreYoneda f a ) where
   dimap con cov ( PreYoneda ax_fy ) =
      PreYoneda ( \ax' -> fmap cov (ax_fy (con . ax')) )
-- BM created this Profunctor because he wants to take End of it
-- End ( ProYoneda f a ) ~ forall x. PreYoneda f a x x

newtype Yoneda f a = Yoneda (forall x. (a -> x) -> f x )

toY :: Functor f => Yoneda f a -> fa
toY ( Yoneda ax_fx ) = ax_fx id

fromY :: Functor f => fa -> Yoneda f a
fromY fa = Yoneda ( \ax -> fmap ax fa )
-- we should prove that they are inverses

--type CoYoneda f a = exists x. (x -> a, f x)
data CoYoneda f a = forall x. CoYoneda (x -> a, f x)
-- CoYoneda f a ~ fa
-- Unit of Composition

--http://www.stephendiehl.com/posts/monads.html
