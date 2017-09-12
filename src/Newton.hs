#!/usr/bin/env stack
-- stack script --resolver=lts-9.4
-- stack script --resolver=ghc-8.2.1
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
   print $ take 7 $ findZero (\x -> x*x - 1) 2.1

   print $ grad (\[x,y,z] -> x * sin (x + log y)) [3.1,2.1,4.4]
   let ppp [x,y,z] = x*y*z
   print $ grad ppp [3,3,3]
   let pppp [x,y,z,v] = x*y*z*v
   print $ grad pppp [3,3,3,3]
   let p [x] = x*x
   print $ grad p [1]

   print $ diff atanh 1.1
   let p2 x = x*x
   print $ diff p2 1
   print "Exit 0"
