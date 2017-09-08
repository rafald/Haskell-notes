-- This is in response to Robert Smallshire's talk titled
-- 'The Unreasonable Effectiveness of Dynamic Typing for Practical Programs'.
-- http://www.infoq.com/presentations/dynamic-static-typing/
-- Around the 30 minute mark he gives an example of what he calls a failure
-- of the F# type system, because it allows him to add energy to torque.
-- I demonstrate here that Haskell's type system is capable of ruling
-- out this nonsense. I have no experience with F#; maybe its type system
-- can do the same, if appropriately handled.

-- We'll need some multiparameter typeclasses.
{-# LANGUAGE MultiParamTypeClasses #-}
-- This one is just for convenience, to derive the Num instances
-- of our units.
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
module Mechanics where

-- We start with a predicate to identify Doubles with a unit.
class Unit a where
  forgetUnit :: a -> Double

-- We'll want to do inter-unit multiplication, distance by force for
-- example, so we describe a ternary relationship for units which can
-- be multiplied.
class (Unit a, Unit b, Unit c) => CompatibleUnits a b c where
  (|*|) :: a -> b -> c

-- We choose metres as our unit of distance.
newtype Distance = Metres Double deriving (Num, Eq, Ord, Show)

instance Unit Distance where
  forgetUnit (Metres x) = x

-- We choose Newtons as our unit of force.
newtype Force = Newtons Double deriving (Num, Eq, Ord, Show)

instance Unit Force where
  forgetUnit (Newtons x) = x

-- We choose Joules as our unit of energy.
newtype Energy = Joules Double deriving (Num, Eq, Ord, Show)

instance Unit Energy where
  forgetUnit (Joules x) = x

-- Here we witness the fact that force * distance can determine energy.
instance CompatibleUnits Force Distance Energy where
  x |*| y = Joules $ forgetUnit x * forgetUnit y

-- We choose Newton-metres as our unit of torque.
newtype Torque = NewtonMetres Double deriving (Num, Eq, Ord, Show)

instance Unit Torque where
  forgetUnit (NewtonMetres x) = x

-- Here we witness the fact that force * distance can determine torque.
instance CompatibleUnits Force Distance Torque where
  x |*| y = NewtonMetres $ forgetUnit x * forgetUnit y

-- Now, on to the tail-end of Mr. Smallshire's example.

-- Push a truck

d_truck = Metres 30.0
f_truck = Newtons 20000.0

-- Must help the type checker with a little hint.
energy_truck :: Energy
energy_truck = f_truck |*| d_truck

-- Undo a nut

f_spanner = Newtons 200.0
d_spanner = Metres 0.2

-- Again, we must disambiguate.
torque_spanner :: Torque
torque_spanner = f_spanner |*| d_spanner

-- The universe implodes?
-- Nope, GHC won't allow it.
--wtf = energy_truck + torque_spanner
-- FAILLS TO COMPILE as expected
--    /home/raf/develop/sandbox/Haskell/src/Mechanics.hs:81:22: error:
--        • Couldn't match expected type ‘Energy’ with actual type ‘Torque’
--        • In the second argument of ‘(+)’, namely ‘torque_spanner’
--          In the expression: energy_truck + torque_spanner
--          In an equation for ‘wtf’: wtf = energy_truck + torque_spanner

