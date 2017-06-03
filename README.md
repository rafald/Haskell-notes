# haskell_sandbox

## How-tos

### [Remove/Uninstall a package that stack installed](http://stackoverflow.com/questions/38636436/how-to-uninstall-a-haskell-package-installed-with-stack#38639959)
This is manual task - no support from [stack](https://docs.haskellstack.org/en/stable/README/) tool. This entails using ghc-pkg unregister and then finding the location of the package on your system and removing it via another tool or simply rm.

```bash
stack install <package name>
# Now remove the package
ghc-pkg unregister <pkg-id>
cd /path/to/stack/packages # This could be something like ~/.local/bin, but is configuration dependent
rm <package name>
```
Packages installed by stack are located deep within ~/.stack/snapshots/x86_64-linux/lts-8.0/8.0.2/

### [Atom - very nice editor for Haskell](https://atom.io)

[How to install on ubuntu](https://codeforgeek.com/2014/09/install-atom-editor-ubuntu-14-04/)

[Plugin ide-haskell to install](https://atom.io/packages/ide-haskell). It depends on language-haskell plugin so you must install it as well.

Assuming you have installed at least [minimal Haskell toolchain](https://www.haskell.org/downloads) , execute the following:
```bash
stack install stylish-haskell # binary deps required by ide-haskell plugin
stack install ghc-mod
stack install hlint
apm install language-haskell haskell-ghc-mod ide-haskell-cabal ide-haskell autocomplete-haskell
```
if necessary, alter PATH to include $HOME/.local/bin so stylish-haskelletc can be run
```bash
export PATH="$HOME/.local/bin:$PATH"
```

### [let in Haskell](https://stackoverflow.com/questions/8274650/in-haskell-when-do-we-use-in-with-let#8274846)
**let expression** 
let variable = expression in expression. This can be used wherever an expression is allowed, e.g.
```Haskell
   (let x = 2 in x*2) + 3
```
**let-statement** 
This form is only used inside of do-notation, and does not use in.
```Haskell
   do statements
     let variable = expression
     statements
```
**let inside of list comprehensions** 
Similar to number 2, again, no in.
```Haskell
    [(x, y) | x <- [1..3], let y = 2*x]
```    
[(1,2),(2,4),(3,6)]

### let vs where
The {assignments} are in scope for the expressions bar and baz, but not for foo.
```Haskell
[ baz | foo, let {assignments ; asss2 }, bar ]
> [ (x,v) | x <-[1..3], let {r = 1 ; g = [4..6] }, v <- g ]
[(1,4),(1,5),(1,6),(2,4),(2,5),(2,6),(3,4),(3,5),(3,6)]
```
the scope of *where* lines up with a particular function definition. So
```Haskell
someFunc x y | guard1 = blah1
             | guard2 = blah2
  where {assignments}
```  
the {assignments} in this where clause _have access to x and y_. 
guard1, guard2, blah1, and blah2 _all have access to the {assignments}_ of this where clause. This can be helpful if multiple guards reuse the same expressions

