# Neovim preferences

based on [NvChad](https://github.com/NvChad/NvChad)

Requirements:

- neovim
- git
- clang
- ttf-jetbrains-mono-nerd  
- nodejs for LSP ([nvm](https://github.com/nvm-sh/nvm) is recommended)
- ruff 

can be installed with:

``` 
pacman -S  neovim, git, clang, ttf-jetbrains-mono-nerd, ruff, nodejs
```

or if you prefer nvm instead of nodejs:

``` 
yay -S nvm
```

## Installation

First, check out the .config/nvim directory, make necessary backups, then execute

```
git clone https://github.com/freedatensuppe/nvim_prefs $HOME/.config/nvim 
```

start nvim and execute 

```
:Lazy 
:MasonInstallAll
```

Neovim should be set up properly now.
