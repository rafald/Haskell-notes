#!/usr/bin/env stack
-- stack script --resolver=ghc-8.2.1 
-- stack runghc --install-ghc
module HPTTConduit where 

import Network.HTTP.Conduit
import qualified Data.ByteString.Lazy as L

main = simpleHttp "http://www.winsoft.sk" >>= L.putStr



