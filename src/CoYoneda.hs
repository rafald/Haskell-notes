-- https://gist.github.com/thoughtpolice/5843762

{-# LANGUAGE ExistentialQuantification, RankNTypes #-}
{-# LANGUAGE InstanceSigs #-}
module CoYoneda where

import Data.IORef
import Data.Set (Set, map)
import Control.Monad (liftM)

--------------------------------------------------------------------------------
-- Yoneda

newtype Yoneda f a = Yo (forall b. (a -> b) -> f b)

-- Yoneda is a functor, but `f` too must be a functor
-- to inhabit such a type (see `liftYo`)
instance Functor (Yoneda f) where
  fmap :: (a -> b) -> Yoneda f a -> Yoneda f b
  fmap f (Yo g) = Yo $ \k -> g (k . f)

liftYo :: Functor f => f a -> Yoneda f a
liftYo x = Yo $ \f -> fmap f x

-- Even Haskellers know the motto.
yolo :: Yoneda f a -> f a
yolo = lowerYo

froyo :: Yoneda f a -> f a
froyo = lowerYo

lowerYo :: Yoneda f a -> f a
lowerYo (Yo f) = f id
{-# DEPRECATED lowerYo
      "use froyo or yolo, as they are significantly more awesome" #-}

--------------------------------------------------------------------------------
-- CoYoneda

data CoYoneda f a = forall b. CoYo (f b) (b -> a)

-- CoYoneda is a functor even when 'f' is not!
instance Functor (CoYoneda f) where
  fmap :: (a -> b) -> CoYoneda f a -> CoYoneda f b
  fmap f (CoYo x g) = CoYo x (f . g)

liftCoYo :: f a -> CoYoneda f a
liftCoYo f = CoYo f id

lowerCoYo :: Functor f => CoYoneda f a -> f a
lowerCoYo (CoYo x f) = fmap f x

lowerCoYoM :: Monad f => CoYoneda f a -> f a
lowerCoYoM (CoYo x f) = liftM f x

--------------------------------------------------------------------------------
{--

Proof that CoYoneda and Yoneda perform equivalent fmap fusion.

CoYoneda:

  lowerCoYo (fmap h (fmap g (liftCoYo x)))
= { defn of liftCoYo }
  lowerCoYo (fmap h (fmap g (CoYo x id)))
= { defn of fmap }
  lowerCoYo (fmap h (CoYo x (g . id))
= { defn of fmap }
  lowerCoYo (CoYo x (h . g . id))
= { defn of lowerCoYo }
  fmap (h . g . id) x
= { defn of id }
  fmap (h . g) x

Yoneda:

  lowerYo $ fmap h $ fmap g $ liftYo x
= { defn of liftYo }
  lowerYo $ fmap h $ fmap g $ Yo (\f -> fmap f x)
= { defn of fmap }
  lowerYo $ fmap h $ Yo (\k -> (\f -> fmap f x) (k . g))
= { defn of fmap }
  lowerYo $ Yo (\l -> (\k -> (\f -> fmap f x) (k . g)) (l . h))
= { defn of lowerYo }
  (\l -> (\k -> (\f -> fmap f x) (k . g)) (l . h)) id
= { beta reduction }
  (\k -> (\f -> fmap f x) (k . g)) (id . h)
= { beta reduction }
  (\f -> fmap f x) (id . h . g)
= { beta reduction }
  fmap (id . h . g) x
= { defn of id }
  fmap (h . g) x

--}

--------------------------------------------------------------------------------
-- CoYoneda-fied IORefs. Note these are effectively read-only, because there
-- is no way to lower the properly typed IORef to modify!

newtype CoYoRef a = CoYoRef (CoYoneda IORef a)

newCoYoRef :: a -> IO (CoYoRef a)
newCoYoRef x = newIORef x >>= return . CoYoRef . liftCoYo

readCoYoRef :: CoYoRef a -> IO a
readCoYoRef (CoYoRef (CoYo r f)) = readIORef r >>= return . f

--------------------------------------------------------------------------------
-- CoYoneda-fied sets.

-- CoYoSet is like Set, but has a Functor instance you can `fmap`!
data CoYoSet a = forall b. Ord b => CoYoSet (Set b) (b -> a)

instance Functor CoYoSet where
  fmap f (CoYoSet s g) = CoYoSet s (f . g)

liftCoYoSet :: Ord a => Set a -> CoYoSet a
liftCoYoSet f = CoYoSet f id

lowerCoYoSet :: Ord a => CoYoSet a -> Set a
lowerCoYoSet (CoYoSet s f) = Data.Set.map f s

