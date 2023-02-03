# dotfiles

Configuration for a terminal-centric development environment on MacOS.

Dotfile management is kept deliberately simple: make `$HOME` a git repository,
ignore everything except dotfiles, and manage install scripts with a simple
Makefile.

Before any of this works, install the XCode command-line tools (running `git`
in a Terminal will open an installation prompt) and upload a new SSH key to
Github.

```
cd ~
git init -b main .
git remote add origin https://github.com/akshayjshah/dotfiles.git
git fetch
git reset --mixed origin/main
make setup
```
