
-- http://www.haskellforall.com/2012/12/the-continuation-monad.html
module Cont where
import Control.Monad (forever)
import Control.Monad.Cont
--import Control.Monad.Cont(cont,runCont,runContT,ContT)
--import Control.Monad.Trans.Control

onInput :: (String -> IO ()) -> IO ()
        -- i.e. Cont (IO ()) String
onInput f = forever $ do
    str <- getLine
    f str




type Target = Int
--unitAttack :: Target -> Cont (IO ()) Target
unitAttack target = cont $ \todo -> do
    -- swingAxeBack 60
    -- valid <- isTargetValid target
    --if valid
    --then todo target
    --else sayUhOh
    todo target


unitAttack2 :: Target -> ContT () IO Target
unitAttack2 target = ContT $ \todo -> do
    todo target

damageTarget :: Target -> IO ()
damageTarget t = print t


calculateLength :: [a] -> Cont r Int
calculateLength subject = return (length subject)

double :: Int -> Cont r Int
double n = return (n * 2)

main = do
 let str = "ala ma asa"
 print str
 runCont (calculateLength str >>= double) print
 fail "premature exit"
 let target = 56
 runCont (unitAttack target) damageTarget
 runContT (unitAttack2 target) damageTarget
 onInput putStr

validateName name exit = do
  when (null name) (exit "You forgot to tell me your name!")
