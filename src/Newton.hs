#!/usr/bin/env stack
-- stack script --resolver=ghc-8.2.1
-- --resolver=lts-9.0
module Newton where
-- https://github.com/ekmett/ad

--import Numeric.AD.Mode.Forward.Double -- Ad was ad
-- it seems module names must start uppercase
--import Numeric.AD.Mode.Forward
--import Numeric.AD.Mode.Kahn
--import Numeric.AD.Mode.Reverse
--import Numeric.AD.Mode.Tower
import Numeric.AD.Rank1.Forward.Double
--import Numeric.AD.Rank1.Forward
--import Numeric.AD.Rank1.Kahn
--import Numeric.AD.Rank1.Tower
--import Numeric.AD
import Debug.SimpleReflect

findZero f = iterate go
             where go xn = let (fxn , f'xn) = diff' f xn in xn - fxn/f'xn

main = do
   --print $ findZero (\x -> x*x - 1)
   --print $ grad (\[x,y,z] -> x * sin (x + log y)) [x,y,z]
   --print $ diff atanh x
   print "Exit 0"
