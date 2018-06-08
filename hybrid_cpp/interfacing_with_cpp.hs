-- stack exec ghc -- -O2 cpp_thread_in_haskell.cpp  -lpthread -threaded interfacing_with_cpp.hs -optl="-lstdc++"
-- OLD ghc -O2 -optc="-std=c++11 -lstdc++" -optl="-lstdc++" cpp_thread_in_haskell.cpp -lpthread -threaded

-- https://www.reddit.com/r/haskell/comments/6iukkz/interfacing_with_vendor_c_library/
-- https://wiki.haskell.org/CPlusPlus_from_Haskell

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

{--
Hello from thread #0
Hello from thread #1
Hello from thread #2
Hello from thread #3
Hello from thread #4
the threads called the callback in the following order:
[0,1,2,3,4]
--}

{--
spawning threads...
the threads called the callback in the following order:
[3,4,1,0,2]
--}
