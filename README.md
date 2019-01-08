# dotfiles

Configuration for a terminal-centric development environment.

Dotfile management is kept deliberately simple: make `$HOME` a git repository,
ignore everything except dotfiles, and manage install scripts with a simple
Makefile.

```
cd ~
git init .
git remote add -t \* -f origin git@github.com:akshayjshah/dotfiles.git
git checkout master
make setup
```
