#!/usr/bin/env stack
-- stack script --resolver=ghc-8.2.1
-- stack --resolver=ghc-8.2.1 --install-ghc runghc -- -Wall -ddump-splices
-- stack --resolver=lts-9.4 --install-ghc runghc -- -Wall -ddump-splices
-- -Werror

{-# LANGUAGE TypeFamilies, OverloadedStrings #-}
module SafeHead where

import Data.Word (Word8)
import qualified Data.ByteString as S
import Data.ByteString.Char8 () -- get an orphan IsString instance

class SafeHead a where
   type Content a -- must be a
   safeHead :: a -> Maybe (Content a)
instance SafeHead [a] where
   type Content [a] = a  -- z not allowed
   safeHead [] = Nothing
   safeHead (x:_) = Just x
instance SafeHead S.ByteString where
   type Content S.ByteString = Word8
   safeHead bs
      | S.null bs = Nothing
      | otherwise = Just $ S.head bs
main :: IO ()
main = do
   print $ safeHead ("" :: String)
   print $ safeHead ("hello" :: String)
   print $ safeHead ("" :: S.ByteString)
   print $ safeHead ("hello" :: S.ByteString)
   print $ safeHead [1, 5] -- RLD
   let spacestr = (" " :: S.ByteString)
   print $ safeHead spacestr
