#!/usr/bin/env stack
-- stack script --resolver=ghc-8.2.1 
-- stack script --resolver=lts-9.1
-- --resolver=ghc-8.2.1
-- --resolver=lts-9.0
{-# LANGUAGE OverloadedStrings #-}

module Httpbin where

import Data.Aeson
import Network.HTTP.Simple
import Network.HTTP.Types.Status

main :: IO ()
main = do
  res <- httpJSON "http://httpbin.org/get"
  if getResponseStatus res == status200
    then print $ (getResponseBody res :: Value)
    else error $ show $ getResponseStatus res

