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
mvsk (n, m1, m2, m3, m4) = (m1, m2/(n-1.0), (sqrt n)*m3/m2**1.5, n*m4/m2**2 - 3.0)

{- The foldl applies moments first to its initial value, the 5-tuple of zeros.
Then it iterates over the data, taking data points one at a time and visiting each point only once,
returning a new state from moments each time.
Another way to say this is that after processing each data point,
moments returns the 5-tuple that it would have returned
if that data only consisted of the values up to that point
-}
online_stats = mvsk . foldl moments (0,0,0,0,0)

main = do
  rs <- sequence [getLine, getLine, getLine, getLine]
  print rs
  --TODO head assumes list is not empty
  let xread = fst . head . reads
  print $ online_stats $ map xread rs

  print $ online_stats [2, 30, 51, 72]

-- prints (38.75, 894.25,-0.1685, -1.2912)
--        (38.75,894.25,-0.16847151077905,-1.29117407893914)
