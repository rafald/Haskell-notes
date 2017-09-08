#!/usr/bin/env stack
-- stack script --resolver=ghc-8.2.1
-- --resolver=lts-9.0
module AvgRadiusEarth where
-- https://www.reddit.com/r/haskell/comments/51a4ho/python_to_haskell/
-- running hugs:
--  withArgs ["2", "b", "c"] main
import  System.Environment
-- Average radius of Earth (m)
_R :: Double
_R = 6.371e6

-- Mass of Earth (kg)
--_M :: Double
--_M = 5.97237e24

-- Average density of Earth (kg/m3)
rho :: Double
rho = 5.514e3

-- Newton's Gravitational Constant (Nm2/kg2)
_G :: Double
_G = 6.674e-11

k :: Double
k = 4.0 * _G * rho * pi / 3.0

-- (a, v, x, t)
type Values = (Double, Double, Double, Double)

iteration :: Double -> Values -> Values
iteration delta_t (a, v, x, t) = (a', v', x', t')
    where a' = -k * x
          v' = v + a' * delta_t
          x' = x + v' * delta_t
          t' = t + delta_t

loop :: Double -> Values -> IO ()
loop delta_v values@(a, v, x, t) -- values
    | x <= 0.0 = return ()
    | otherwise = do { putStrLn (show values); loop delta_v $ iteration delta_v values }

main :: IO ()
main = do
    args <- getArgs
    let delta_v = read $ args !! 0 :: Double
    loop delta_v (a, v, x, t)
    where a = 0.0
          v = 0.0
          x = _R
          t = 0.0


