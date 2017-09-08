#!/usr/bin/env stack
-- stack script --resolver nightly-2017-08-20
-- stack --verbosity info script --resolver=ghc-8.2.1 --package network
-- stack --verbosity info --resolver nightly-2017-07-11 script
-- stack --verbosity info --resolver lts-9.0 script
{-# LANGUAGE OverloadedStrings #-}

module Http where

import qualified Data.ByteString.Lazy.Char8 as L8
import           Network.HTTP.Simple

main :: IO ()
main = do
    response <- httpLBS "http://httpbin.org/get"
    putStrLn $ "The status code was: " ++
               show (getResponseStatusCode response)
    print $ getResponseHeader "Content-Type" response
    L8.putStrLn $ getResponseBody response
