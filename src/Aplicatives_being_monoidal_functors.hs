#!/usr/bin/env stack
-- stack script --resolver=ghc-8.2.1 
-- --resolver=lts-9.0
module Aplicatives_being_monoidal_functors where
--When using the script command, you must provide a resolver argument


-- difficult because monoids are implicit

main = putStr $ show $ ("julie", (<3)) <*> ("rocks", 2)
