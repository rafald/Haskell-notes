module MatchOnResult where

type Env = String -> Value

emptyEnv :: Env
emptyEnv = const undefined

data Value =  Closure String Exp Env
instance Show Value where
  show (Closure s expr _) = s ++ show expr

valstr :: Value -> String
valstr (Closure s _ _ ) = s

data Exp = Val String deriving Show
{-
extend:: String -> Value -> Env -> Env -- variable
Env <=> String-> Value
-}
extend:: String -> Value -> (String -> Value) -> (String -> Value) -- variable
extend i v f j
  | i == j = v
  | otherwise = f j

main :: IO ()  
main = do
  let y = extend "zmienna1" (Closure "wartosc1" (Val "WARTOSC2") emptyEnv) emptyEnv
      z = y "zmienna1"
  print $ show z
  let z2 = y "badname"
  print $ show z2

