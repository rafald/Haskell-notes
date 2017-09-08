
module ContT where
   
import Control.Monad.Cont
import System.IO

main = do
  hSetBuffering stdout NoBuffering
  runContT (callCC askString) reportResult

-- RLD the first arg 'next' is current continuation captured at call site of callCC
-- its type is: String -> ContT () IO String
-- askString :: (String -> ContT () IO String) -> ContT () IO String
askString next = do
  liftIO $ putStrLn "Please enter a string"
  s <- liftIO $ getLine
  --liftIO $ putStrLn (show next)
  next s

--reportResult :: String -> IO ()
reportResult s = putStrLn ("You entered: " ++ s)
--reportResult s = do
--  putStrLn ("You entered: " ++ s)
