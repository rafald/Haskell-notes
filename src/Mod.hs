#!/usr/bin/env stack
-- stack exec runghc --resolver=lts-9.4 --package singletons
-- stack script --resolver=ghc-8.2.1

{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE UndecidableInstances #-}

module Mod where

import Data.Singletons
import Data.Promotion.Prelude
import Numeric.Natural
import Data.Word
import GHC.TypeLits

newtype Mod' (n :: Nat) a = Mod a
                       deriving (Eq, Ord, Show)

fromNum :: forall n a. (KnownNat n, Integral a) => a -> Mod' n a
fromNum x = Mod (x `mod` fromIntegral (natVal (Proxy @n)))

type family Width (n :: Nat) where
    Width n =
        If (n :< 0x100)
           Word8
           (If (n :< 0x10000)
               Word16
               (If (n :< 0x100000000)
                   Word16
                   Natural
               ))

type Mod (n :: Nat) = Mod' n (Width n)

main :: IO ()
main = print (fromNum 42 :: Mod 13)
