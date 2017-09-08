{-# LANGUAGE DataKinds, KindSignatures, ScopedTypeVariables #-}
module SomeNat where

import GHC.TypeLits
import Data.Proxy

-- http://stackoverflow.com/questions/30752653/can-i-have-an-unknown-knownnat

data Bar (n :: Nat) = Bar String deriving Show

bar :: KnownNat n => Bar n -> (String, Integer)
bar b@(Bar s) = (s, natVal b)

-- Ok, it's very pointless. But it's an example of using KnownNat to get at compile-time information. But thanks to the other functions in GHC.TypeLits, it can be used with run-time information as well.

-- Just add this on to the above code, and try it out.

main :: IO ()
main = do
    i <- readLn
    let Just someNat = someNatVal i
    case someNat of
       SomeNat (_ :: Proxy n) -> do
           let b :: Bar n
               b = Bar "hello!"
           print $ bar b

--    Read an Integer from stdin.
--    Create a SomeNat-typed value from it, failing the pattern-match if the input was negative. For such a simple example, handling that error just gets in the way.
--    Here's the real magic. Pattern-match with a case expression, using ScopedTypeVariables to bind the (statically unknown) Nat-kinded type to the type variable n.
--    Finally, create a Bar value with that particular n as its type variable and then do things with it.

