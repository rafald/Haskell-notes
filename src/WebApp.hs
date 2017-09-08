#!/usr/bin/env stack
-- stack script --resolver=lts-9.1 --package happstack
-- --compiler ghc-8.2.1
-- stack runghc --install-ghc
module WebApp where

--import           Happstack.Server.Env
import           Happstack.Server
import           System.Environment

main = do
    environment <- getEnvironment
    simpleHTTP nullConf $ ok $ show environment
