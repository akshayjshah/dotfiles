# dotfiles

Configuration for a terminal-centric ChromeOS development environment (using
the default Debian Linux container).

Dotfile management is kept deliberately simple: make `$HOME` a git repository,
ignore everything except dotfiles, and manage install scripts with a simple
Makefile.

## Installation

```
cd ~
git clone https://github.com/akshayjshah/dotfiles.git .
make setup
```
