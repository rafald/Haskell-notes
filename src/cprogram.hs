#!/usr/bin/env stack
-- stack script --resolver=ghc-8.2.1 
-- stack runghc --install-ghc
module Cprogram where

{-# START_FILE main.hs #-}
import System.Process

main = do
    system "clang++-4.0 main.c"
    system "./a.out"

{-# START_FILE main.c #-}
#include <iostream>

using namespace std;

int main() {
    cout << "Hello, world!\n";
    return 0;
}

