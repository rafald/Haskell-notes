#!/usr/bin/env stack
-- stack --resolver=ghc-8.2.1 runghc -- -fglasgow-exts -O -simpl-stats 

{-# LANGUAGE ExistentialQuantification #-}
module RULE where

import Data.Text.Conversions
{-# RULES 
    "drop xxx/yyy" forall t. Data.Text.Conversions.fromText ( Data.Text.Conversions.toText t ) = t
 #-}

class Shape_ a where
   perimeter :: a -> Double
   area      :: a -> Double

-- instances of Shape are made from Shape_ 
data Shape = forall a. Shape_ a => Shape a
 
type Radius = Double
type Side   = Double
 
data Circle    = Circle    Radius
data Rectangle = Rectangle Side Side
data Square    = Square    Side
 
 
instance Shape_ Circle where
   perimeter (Circle r) = 2 * pi * r
   area      (Circle r) = pi * r * r
 
instance Shape_ Rectangle where
   perimeter (Rectangle x y) = 2*(x + y)
   area      (Rectangle x y) = x * y
 
instance Shape_ Square where
   perimeter (Square s) = 4*s
   area      (Square s) = s*s
 
instance Shape_ Shape where
   perimeter (Shape shape) = perimeter shape
   area      (Shape shape) = area      shape
 
 
 --
 -- Smart constructor
 --
 
circle :: Radius -> Shape
circle r = Shape (Circle r)
 
rectangle :: Side -> Side -> Shape
rectangle x y = Shape (Rectangle x y)
 
square :: Side -> Shape
square s = Shape (Square s)
 
shapes :: [Shape]
shapes = [circle 2.4, rectangle 3.1 4.4, square 2.1]


main = putStr $ "dupa" -- show shapes
