#!/usr/bin/env stack
-- stack script --resolver=ghc-8.2.1 
-- stack runghc --install-ghc

-- http://stackoverflow.com/questions/24234517/understanding-withfile-with-example#24234875
module WithFile where

import System.IO
import Control.Monad
import System.Environment

withFile' :: FilePath -> IOMode -> (Handle -> IO a) -> IO a  
withFile' path iomode f = do
	handle <- openFile path iomode
	result <- f handle -- delayed read, do not use partial application here
	hClose handle
	return result -- lazy list

-- Because of lazy evaluation, hGetContents only reads the file if it needs to, 
-- i.e. is forced to in order to produce output for some other function.

-- *** Exception: withFile.hs: hGetContents: illegal operation (delayed read on closed handle)
main = do
        pname <- getProgName
	withFile' pname ReadMode (hGetContents >=> putStr)
	-- (the brackets are unnecessary but clarifying in the second example).
	(withFile' pname ReadMode hGetContents) >>= putStr
