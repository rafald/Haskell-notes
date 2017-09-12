#!/usr/bin/env stack
-- stack script --resolver=lts-9.4
-- --package turtle
-- stack script --resolver=ghc-8.2.1 --package turtle
-- stack --verbosity info runghc --install-ghc --package turtle

-- lts-7.9 
--6.24

{-# LANGUAGE OverloadedStrings #-}
module Turtle_script where

import Turtle

main :: IO ()
main = echo "Hello World!"

{-
$ stack ghci turtle
Prelude> :set -XOverloadedStrings
Prelude> import Turtle
-}


