#!/usr/bin/env stack
-- stack exec ghc -- -D="CLASSES=''"
{-# LANGUAGE CPP #-}
module Cpp_preproc where
--module M where
data T = C deriving (CLASSES)


