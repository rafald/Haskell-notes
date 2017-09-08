#!/usr/bin/env stack
-- stack script --resolver=ghc-8.2.1 
-- stack runghc --install-ghc
module E2 where

-- | Parse string to list of commands
--
-- Examples:
--
-- >>> parseInput "compile runTest run arg1 33 arg3 " 
-- [ Compile, RunTest, Run ["arg1", 33, "arg3"] ]
--
-- >>> parseInput " PrintNL " 
-- [ PrintNewLine ]
parseInput :: [Char] -> [Command]
parseInput chars = takeWhile notQuit (map parseCommand chars)

main :: IO ()
main = do
   putStr "Wow!"

