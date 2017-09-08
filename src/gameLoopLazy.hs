#!/usr/bin/env stack
-- stack script --resolver=ghc-8.2.1 
-- stack runghc --install-ghc
module GameLoopLazy where

-- forM_ :: (Foldable t,    Monad m) => t a -> (a -> m b) -> m ()
-- forM  :: (Traversable t, Monad m) => t a -> (a -> m b) -> m (t b)
-- The forM_ function is more efficient because it does not save the results of the operations /m: intermediate results of the game/
-- However, because of laziness, the list returned by forM is never computed unless used . In other words, whenever one does not need the resulting list, forM could be used in place of forM_ with no loss of efficiency. But forM_ is preferred becasue it has a more informative type in this case.

main = do
   userInput <- getContents
   let commands = map parseCommand userInput
   let gameStates = playGame startingState commands
   forM_ gameStates render

