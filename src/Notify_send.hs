#!/usr/bin/env stack
-- stack --verbosity info --install-ghc script --resolver=ghc-8.2.1
-- --resolver lts-9.4
--resolver=nightly-2017-08-19

module Notify_send where


import           DBus.Client
import           DBus.Notify

main :: IO Notification
main = do
         print "Started."
         client <- DBus.Client.connectSession -- mkSessionClient -- sessionConnect
         let startNote = appNote { summary="Starting" --,hints = [Urgency Critical] --expiry = Dependent -- Never
                                 , body=Just $ Text "Calculating fib(33)." }
         notification <- notify client startNote
         let endNote = appNote { summary="Finished" --, hints = [Urgency Critical] -- expiry = Never -- Milliseconds 0 -- notify_send.hs: notification timeout not positive
                               , body=Just . Text . show $ fib33 }
         -- fib33 `seq` replace client notification endNote
         replace client notification endNote
     where
         appNote = blankNote { appName="Fibonacci Demonstration" }
         fib 0 = 0
         fib 1 = 1
         fib n = fib (n-1) + fib (n-2)
         fib33 = fib 33
