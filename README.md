# nix-develop.nvim

`nix develop` for neovim

```vim
:NixDevelop
:NixDevelop .#foo
:NixDevelop --impure

:NixShell
:NixShell nixpkgs#hello
```

## [devenv](https://github.com/cachix/devenv) integration

```vim
:DevenvShell
:DevenvShell --profile foo
```

## [riff (unmaintained)](https://github.com/DeterminateSystems/riff) integration

```vim
:RiffShell
:RiffShell --project-dir foo
```

See [nix-develop.txt](doc/nix-develop.txt) for more information
