-- stack exec ghc -- -O2 thread_in_haskell.c -lpthread -threaded interfacing_with_c.hs

-- https://www.reddit.com/r/haskell/comments/6iukkz/interfacing_with_vendor_c_library/

import Control.Concurrent.STM
import Data.Foldable
import Foreign.Ptr
import Text.Printf

type Callback = Int -> IO ()
foreign import ccall "wrapper"
  mkCallback :: Callback -> IO (FunPtr Callback)

foreign import ccall spawn_threads :: Int -> FunPtr Callback -> IO ()

callback :: TVar [Int] -> Callback
callback tvar i = atomically $ modifyTVar tvar (++ [i])

main :: IO ()
main = do
  tvar <- newTVarIO []
  callbackPtr <- mkCallback (callback tvar)

  putStrLn "spawning threads..."
  spawn_threads 5 callbackPtr

  putStrLn "the threads called the callback in the following order:"
  xs <- atomically (readTVar tvar)
  print xs
{--
spawning threads...
the threads called the callback in the following order:
[4,3,2,1,0]
--}

