# dotfiles

Configuration for a terminal-centric development environment on Arch Linux.

Dotfile management is kept deliberately simple: make `$HOME` a git repository,
ignore everything except dotfiles, and manage install scripts with a simple
Makefile.

Before any of this works, upload a new SSH key to Github.

```
cd ~
git init -b main .
git remote add origin https://github.com/akshayjshah/dotfiles.git
git fetch
git reset --mixed origin/main
make setup
```
