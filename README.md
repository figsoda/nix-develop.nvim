# nix-develop.nvim

`nix develop` for neovim

```vim
:NixDevelop
:NixShell
:RiffShell

:NixDevelop .#foo
:NixDevelop --impure
:NixShell nixpkgs#hello
:RiffShell --project-dir foo
```

See [nix-develop.txt](doc/nix-develop.txt) for more information
