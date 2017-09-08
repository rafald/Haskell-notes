#!/usr/bin/env stack
-- stack script --resolver=lts-9.1
-- ghc-8.2.1 
-- stack --verbosity info runghc --install-ghc --package turtle

-- #!/usr/bin/env runhaskell

{-# LANGUAGE OverloadedStrings #-}
module Turtle_example where

import Turtle

main :: IO ()
main = do
    cd "/tmp"
    mkdir "test"
    output "test/foo" "Hello, world!"  -- Write "Hello, world!" to "test/foo"
    stdout (input "test/foo")          -- Stream "test/foo" to stdout
    rm "test/foo"
    rmdir "test"
    sleep 1
    die "Urk!"
