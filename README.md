# haskell_sandbox

## How-tos

### [Remove/Uninstall a package that stack installed](http://stackoverflow.com/questions/38636436/how-to-uninstall-a-haskell-package-installed-with-stack#38639959)
This is manual task - no support from stack. This entails using ghc-pkg unregister and then finding the location of the package on your system and removing it via another tool or simply rm.

```bash
stack install <package name>
# Now remove the package
ghc-pkg unregister <pkg-id>
cd /path/to/stack/packages # This could be something like ~/.local/bin, but is configuration dependent
rm <package name>
```
Packages installed by stack are located deep within ~/.stack/snapshots/x86_64-linux/lts-8.0/8.0.2/

