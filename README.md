# dotfiles

Configuration for a terminal-centric development environment in WSL2.

Dotfile management is kept deliberately simple: make `$HOME` a git repository,
ignore everything except dotfiles, and manage install scripts with a simple
Makefile.

```
cd ~
git init .
git remote add origin https://github.com/akshayjshah/dotfiles.git
git fetch
git reset --mixed origin/master
make setup
```
