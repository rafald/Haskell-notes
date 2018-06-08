#!/usr/bin/env stack
-- stack script --resolver=ghc-8.2.1
-- stack --install-ghc runghc --package network -- -Wall -Werror

module Better_exceptions_8 where

import Control.Monad (forM, forM_)
import Network       (PortID (PortNumber), PortNumber, connectTo)
import System.IO     (hClose, hPutStrLn)

dests :: [(String, PortNumber)]
dests =
    [ ("52.73.238.124",80), ("localhost", 80)
    , ("localhost", 8080)
    , ("10.0.0.138", 80)
    ]

main :: IO ()
main = do
    handles <- forM dests $ \(host, port) -> do
         print (host, port)
         connectTo host (PortNumber port)
    forM_ handles $ \h -> hPutStrLn h "GET / HTTP/1.1\r\n\r\n"
    forM_ handles hClose
