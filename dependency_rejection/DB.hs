module DB(Reservation(..), readReservations, createReservation, accept, quantity) where

import           Data.Time

newtype Reservation = Reservation { isAccepted :: Bool }

--makeRes :: Bool -> Reservation
--makeRes x = Reservation x

accept :: Reservation -> Reservation
accept r = r { isAccepted = True }

quantity :: Reservation -> Int
quantity _ = 23

readReservations :: String -> Day -> IO [Reservation]
readReservations _ _ = do return $ [Reservation True]

createReservation :: String -> Reservation -> IO Int
createReservation _ _ = do return 2
--createReservation _ = do return $ Reservation False

testAccesor :: Reservation -> Bool
testAccesor r = isAccepted r
