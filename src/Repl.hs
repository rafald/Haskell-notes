#!/usr/bin/env stack
-- stack script --resolver lts-9.3
--nightly-2017-08-20
module Repl where

import           System.IO

type Env = [(String, String)]

loop :: Env -> IO Env
loop env = do
    str <- putStr ">>> " >> hFlush stdout >> getLine
    if (str == "quit")
    then return []
    else do
      let (ans, env') = evalString env str
      putStrLn ans
      loop env'

evalString :: Env -> String -> (String, Env)
evalString env (c : '=' : str) = ("ok", ([c], str) : env)
evalString env [c] = case lookup [c] env of
      Nothing  -> ("unknown", env)
      Just str -> (str, env)
evalString env _ = ("eh?", env)

main :: IO ()
main = loop [] >> return ()

