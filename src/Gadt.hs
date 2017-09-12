#!/usr/bin/env stack
-- stack runghc --resolver=ghc-8.2.1 --package free --package bifunctors --package comonad --package distributive --package exceptions --package mtl --package prelude-extras --package profunctors --package semigroupoids --package semigroups --package transformers-compat --package base-orphans --package cabal-doctest --package contravariant --package hashable --package stm --package tagged --package unordered-containers --package StateVar --package text --package void
-- stack --verbosity info --install-ghc script --resolver=ghc-8.2.1
--{-# LANGUAGE GADTs #-}

-- https://gist.github.com/avieth/334201aa341d9a00c7fc

{-# LANGUAGE GADTs #-} 
--MultiParamTypeClasses ,FlexibleInstances ,FlexibleContexts ,RankNTypes ,KindSignatures ,GADTs ,GeneralizedNewtypeDeriving ,DeriveFunctor ,TypeOperators ,OverlappingInstances #-}

module Gadt where

import Prelude hiding (log)
import Control.Applicative
import Control.Monad
import Control.Monad.Free
import Control.Monad.IO.Class
import Control.Monad.Trans.Class
import Control.Monad.Trans.Identity
import Control.Monad.Trans.Reader

data PlusF a where
   Plus :: Int ->Int ->(Int ->a) ->PlusF a

instance Functor PlusF where
    fmap f (Plus left right next) = Plus left right (fmap f next)

data LogF s a where
    Log :: s ->a ->LogF s a

instance Functor (LogF s) where
    fmap f (Log s next) = Log s (f next)

type Plus = Free PlusF
type Log s = Free (LogF s)

plus :: Int ->Int ->Plus Int
plus i j = liftF $ Plus i j id

log :: s ->Log s ()
log s = liftF $ Log s ()

main = print "."
