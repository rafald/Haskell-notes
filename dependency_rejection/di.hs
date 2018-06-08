import           Control.Monad.IO.Class
import           Control.Monad.Trans.Maybe
import           Data.Time
import           DB                        (Reservation (..), accept, quantity)
import qualified DB                        (createReservation, readReservations)


--      then Just $ reservation { isAccepted = True }
-- type Reservation = DB.Reservation
tryAccept :: Int -> [Reservation] -> Reservation -> Maybe Reservation
tryAccept capacity reservations reservation =
  let reservedSeats = sum $ map quantity reservations
  in  if reservedSeats + quantity reservation <= capacity
      then Just $ accept reservation
      else Nothing



connectionString = "DB.wrwerw:erwe"
--date :: Day
date = fromGregorian 1991 2 4

--  liftIO (DB.readReservations connectionString $ date reservation)
tryAcceptComposition :: Reservation -> IO (Maybe Int)
tryAcceptComposition reservation = runMaybeT $
  liftIO (DB.readReservations connectionString $ date )
  >>= MaybeT . return . flip (tryAccept 10) reservation
  >>= liftIO . DB.createReservation connectionString

main =
  tryAcceptComposition $ Reservation False
