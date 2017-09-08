#!/usr/bin/env stack
-- stack script --resolver lts-9.3 --package conduit-combinators --package conduit-extra --package text --package filepath --package cryptonite --package cryptonite-conduit --package http-conduit --package bytestring
{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE PackageImports ,StandaloneDeriving #-}
{-# LANGUAGE OverloadedStrings #-} -- for httpSink <Request>
-- https://github.com/snoyberg/conduit#readme
module ConduitTest2 where

import Conduit
import Data.Monoid (Sum (..))
--import Data.Text hiding (take, takeWhile, toUpper, map)--(Text)
import Data.Text (Text)

import qualified System.IO as IO
import qualified Data.Conduit.Binary as CB

import System.FilePath (takeExtension)

import qualified System.IO as IO
import Data.ByteString (ByteString)

import qualified Data.Text as T
import Data.Char (toUpper)

import Data.Void (Void)

import "cryptonite-conduit" Crypto.Hash.Conduit (sinkHash)
import "cryptonite" Crypto.Hash (Digest, SHA256)
import Data.Void (Void)

import "cryptonite-conduit" Crypto.Hash.Conduit (sinkHash)
import "cryptonite" Crypto.Hash (Digest, SHA256)
import Data.Void (Void)
import Network.HTTP.Simple (httpSink)

import Data.String

doubles :: [Double]
doubles = [1, 2, 3, 4, 5, 6]

average :: Monad m => ConduitM Double Void m Double
average =
    getZipSink (go <$> ZipSink sumC <*> ZipSink lengthC)
  where
    go total len = total / fromIntegral len

sourceFile' :: MonadResource m => FilePath -> ConduitM i ByteString m ()
sourceFile' fp =
    bracketP (IO.openBinaryFile fp IO.ReadMode) IO.hClose sourceHandle

sinkFile' :: MonadResource m => FilePath -> ConduitM ByteString o m ()
sinkFile' fp =
    bracketP (IO.openBinaryFile fp IO.WriteMode) IO.hClose sinkHandle

--deriving instance IsText (String)
--deriving instance IsString(T.Text)
message :: Text
message = T.pack "This is my message. Try to decode it with the base64 command.\n"

trans :: Monad m => ConduitM Int Int m ()
trans = do
    takeC 5 .| mapC (+ 1)
    mapC (* 2)

magic :: Int -> IO Int
magic x = do
    putStrLn $ "I'm doing magic with " ++ show x
    return $ x * 2

main = do
    -- Pure operations: summing numbers.
    print $ runConduitPure $ yieldMany [1..10] .| sumC
    -- Exception safe file access: copy a file.
    writeFile "input.txt" "This is a test." -- create the source file
    runConduitRes $ sourceFileBS "input.txt" .| sinkFile "output.txt" -- actual copying
    readFile "output.txt" >>= putStrLn -- prove that it worked
    -- Perform transformations.
    print $ runConduitPure $ yieldMany [1..10] .| mapC (+ 1) .| sinkList
    --
    putStrLn "List version:"
    mapM_ print $ takeWhile (< 18) $ map (* 2) $ take 10 [1..]
    putStrLn ""
    putStrLn "Conduit version:"
    runConduit
          $ yieldMany [1..]
         .| takeC 10
         .| mapC (* 2)
         .| takeWhileC (< 18)
         .| mapM_C print
    --
    putStrLn "List version:"
    mapM magic (take 10 [1..]) >>= mapM_ print . takeWhile (< 18)
    putStrLn ""
    putStrLn "Conduit version:"
    runConduit
          $ yieldMany [1..]
         .| takeC 10
         .| mapMC magic
         .| takeWhileC (< 18)
         .| mapM_C print
    --
    let go [] = return ()
        go (x:xs) = do
            y <- magic x
            if y < 18
                then do
                    print y
                    go xs
                else return ()
    --
    go $ take 10 [1..]
    --
    print $ getSum $ runConduitPure $ yieldMany [1..100 :: Int] .| foldMapC Sum
    --
    runConduit
      $ yield message
     .| encodeUtf8C
     .| encodeBase64C
     .| stdoutC
    --
    runConduit $ yieldMany [1..10] .| trans .| mapM_C print
    --
    IO.withBinaryFile "input.txt" IO.ReadMode $ \inH -> IO.withBinaryFile "output.txt" IO.WriteMode $ \outH -> runConduit $ CB.sourceHandle inH .| CB.sinkHandle outH
    --
    runResourceT
     $ runConduit
     $ sourceFile' "input.txt"
     .| sinkFile' "output.txt"
    --
    runConduitRes
     $ sourceDirectoryDeep True "."
     .| filterC (\fp -> takeExtension fp == ".hs")
     .| awaitForever sourceFileBS
     .| sinkFileBS "all-haskell-files"
    --
    runConduitRes
      $ sourceFile "input.txt"
     .| decodeUtf8C
     .| mapC (T.map toUpper)
     .| encodeUtf8C
     .| stdoutC
    --
    print $ runConduitPure $ yieldMany doubles .| average
    --
    digest <- runConduitRes
               $ sourceFile "input.txt"
               .| getZipSink (ZipSink (sinkFile "output.txt") *> ZipSink sinkHash)
    print (digest :: Digest SHA256)
    -- 
    digest2 <- runResourceT $ httpSink "http://httpbin.org"
              (\_res -> getZipSink (ZipSink (sinkFile "output.txt") *> ZipSink sinkHash))
    print (digest2 :: Digest SHA256)
    --
    runConduitRes $ sourceFile "input.txt" .| decodeUtf8C .| (do
      len <- lineC lengthCE
      liftIO $ print len)
    --
    runConduitRes $ sourceFile "input.txt" .| decodeUtf8C .| peekForeverE (do
      len <- lineC lengthCE
      liftIO $ print len)
    print "Hello world!"
