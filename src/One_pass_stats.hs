#!/usr/bin/env stack
-- stack script --resolver=ghc-8.2.1 
-- stack runghc --install-ghc

{-# LANGUAGE AllowAmbiguousTypes   #-}
{-# LANGUAGE PartialTypeSignatures #-}
{-# LANGUAGE RankNTypes            #-}
module One_pass_stats where

moments :: forall t.
            Floating t =>
            (t, t, t, t, t) -> t -> (t, t, t, t, t)
moments (n, m1, m2, m3, m4) x = (n', m1', m2', m3', m4')
        where
            n' = n + 1
            delta = x - m1
            delta_n = delta / n'
            delta_n2 = delta_n**2
            t = delta*delta_n*n
            m1' = m1 + delta_n
            m4' = m4 + t*delta_n2*(n'*n' - 3*n' + 3) + 6*delta_n2*m2 - 4*delta_n*m3
            m3' = m3 + t*delta_n*(n' - 2) - 3*delta_n*m2
            m2' = m2 + t

-- mean, variance, skewness, and kurtosis fro moments
mvsk :: forall t t1.
          Floating t1 =>
          (t1, t, t1, t1, t1) -> (t, t1, t1, t1)
mvsk (n, m1, m2, m3, m4) = (m1, m2/(n-1.0), sqrt n*m3/m2**1.5, n*m4/m2**2 - 3.0)

{- The foldl applies moments first to its initial value, the 5-tuple of zeros.
Then it iterates over the data, taking data points one at a time and visiting each point only once,
returning a new state from moments each time.
Another way to say this is that after processing each data point,
moments returns the 5-tuple that it would have returned
if that data only consisted of the values up to that point
-}
onlineStats :: [Double] -> (Double, Double, Double, Double)
onlineStats = mvsk . foldl moments (0,0,0,0,0)

-- TODO return Maybe or Either
-- TODO it seems that t type is inferred from calling function !
-- safeRead :: forall t. Read t => String -> t
safeRead :: Read t => String -> t
safeRead inStr = case reads inStr of
  []         -> error $ "Parse failed for: " ++ inStr
  (parse1:_) -> fst parse1

main :: IO ()
main = do
  print $ Just 3
  rs <- sequence [getLine, getLine, getLine, getLine]
  print rs
  -- DOES NOT COMPILE print $ map safeRead rs
  print $ onlineStats $ map safeRead rs -- only first number from each sublist is used

  print $ onlineStats [2, 30, 51, 72]
-- prints (38.75, 894.25,-0.1685, -1.2912)
--        (38.75,894.25,-0.16847151077905,-1.29117407893914)
