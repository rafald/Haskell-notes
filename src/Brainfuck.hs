{-# LANGUAGE GeneralizedNewtypeDeriving ,StandaloneDeriving ,TypeSynonymInstances ,FlexibleInstances ,MultiParamTypeClasses #-}

module Brainfuck where

-- https://pastebin.com/tSDgNVCD

import Control.Monad (forever, unless, void)
import Control.Arrow
import Control.Applicative
import Control.Monad.State.Class (get, put, modify, MonadState)
import Control.Monad.Trans (MonadIO, liftIO)
import Control.Monad.Trans.State.Lazy hiding (get, put, modify)
import Data.Char (ord,chr)
import System.Environment (getArgs)
import System.IO (hFlush, stdout)

data Zipper a = Zipper [a] a [a]

type Cells = Zipper Int

newtype Brainfuck a = Brainfuck { runBrainfuck :: StateT Cells IO a }
    deriving (Functor,Applicative)
--    deriving (Functor, Monad, MonadState Cells, MonadIO)
deriving instance Monad Brainfuck
deriving instance MonadIO Brainfuck
deriving instance (MonadState Cells) Brainfuck

instance Show a => Show (Zipper a) where
    show (Zipper bs c as) = show (reverse $ take 5 bs) 
                    ++ " " ++ show c ++ " "
                    ++ show (take 5 as)

start :: Cells
start = Zipper [0,0..] 0 [0,0..]

-- basic functions to modify the cells

moveRight, moveLeft :: Zipper a -> Zipper a
moveRight (Zipper bs c (a:as)) = Zipper (c:bs) a as
moveLeft  (Zipper (b:bs) c as) = Zipper bs b (c:as)

increase, decrease :: Cells -> Cells
increase  (Zipper a b c) = Zipper a (b+1) c
decrease  (Zipper a b c) = Zipper a (b-1) c

extract :: Zipper a -> a
extract (Zipper _ c _) = c

putCurrent :: a -> Zipper a -> Zipper a
putCurrent b (Zipper a _ c) = Zipper a b c

-- brainfuck commands

incPtr :: Brainfuck ()
incPtr = modify moveRight

decPtr :: Brainfuck ()
decPtr = modify moveLeft

incVal :: Brainfuck ()
incVal = modify increase

decVal :: Brainfuck ()
decVal = modify decrease

bfPrint :: Brainfuck ()
bfPrint = fmap (chr . extract) get >>= liftIO . putChar

bfGetChar :: Brainfuck Char
bfGetChar = liftIO getChar

bfWriteChar :: Char -> Brainfuck ()
bfWriteChar c = modify (putCurrent $ ord c)

bfRead :: Brainfuck ()
bfRead = bfGetChar >>= bfWriteChar

bfWhile :: Brainfuck () -> Brainfuck ()
bfWhile cs = do
    cur <- fmap extract get
    unless (cur == 0) (cs >> bfWhile cs)

-- parsing stuff

parseString :: String -> Brainfuck ()
parseString = parse . filter (`elem` ("><+-.,[]":: String) )

parse :: String -> Brainfuck ()
parse [] = return ()
parse ('[':cs) = uncurry (>>) . fmap parse $ parseWhile cs
parse (']':cs) = error "parse error:  ']' before corresponding '[' "
parse (c:cs) = parseChar c >> parse cs

parseWhile :: String -> (Brainfuck (), String)
parseWhile = parsew (return ())
    where parsew bf (']':cs) = (bfWhile bf,cs)
          parsew bf ('[':cs) = uncurry parsew $ first (bf>>) (parseWhile cs)
          parsew bf (c:cs) = parsew (bf>>parseChar c) cs
          parsew _ [] = error "parse error: '[' without corresponding ']'"

parseChar :: Char -> Brainfuck ()
parseChar '>' = incPtr
parseChar '<' = decPtr
parseChar '+' = incVal
parseChar '-' = decVal
parseChar '.' = bfPrint
parseChar ',' = bfRead
parseChar c = error $ "parseChar error: " ++ show c

-- running stuff

runString :: String -> IO Cells
runString = flip execStateT start . runBrainfuck . parseString

runFile :: String -> IO Cells
runFile s = readFile s >>= runString

-- interactive mode

runInteractive :: IO ()
runInteractive = interactive start

interactFile :: String -> IO ()
interactFile s = runFile s >>= interactive

interactive = evalStateT . runBrainfuck . forever $ do
    get >>= liftIO . print
    liftIO $ putStr "input: " >> hFlush stdout
    liftIO getLine >>= parseString
    liftIO $ putStrLn "" >> hFlush stdout

main = do
    args <- getArgs
    case args of
        [] -> runInteractive
        ("-i":file:as) -> interactFile file
        (file:as) -> void $ runFile file
