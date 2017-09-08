#!/usr/bin/env stack
-- stack script --resolver=ghc-8.2.1 
-- stack --install-ghc --resolver=ghc-8.2.1 runghc --package network -- -Wall -Werror
-- stack --install-ghc --resolver lts-5.10 runghc --package network -- -Wall -Werror
module Better_exceptions where

{-# LANGUAGE DeriveDataTypeable #-}
import Control.Exception (Exception, IOException, catch, throwIO)
import Control.Monad     (forM, forM_)
import Data.Typeable     (Typeable)
import Network           (HostName, PortID (PortNumber), PortNumber, connectTo)
import System.IO         (Handle, hClose, hPutStrLn)

data ConnectException = ConnectException HostName PortID IOException
    deriving (Show, Typeable)
instance Exception ConnectException

connectTo' :: HostName -> PortID -> IO Handle
connectTo' host port = connectTo host port `catch`
    \e -> throwIO (ConnectException host port e)

dests :: [(String, PortNumber)]
dests =
    --[ ("localhost", 80)
    [ ("52.73.238.124",80), ("127.0.0.1", 80)
    --, ("localhost", 8080)
    , ("127.0.0.1", 8080)
    , ("10.0.0.138", 80)
    ]

main :: IO ()
main = do
    handles <- forM dests $ \(host, port) -> do
       print (host, port)
       connectTo' host (PortNumber port)
    forM_ handles $ \h -> hPutStrLn h "GET / HTTP/1.1\r\n\r\n"
    forM_ handles hClose

