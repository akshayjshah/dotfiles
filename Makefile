.DEFAULT_GOAL := help

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'

.PHONY: all
all: brew-pkg go-pkg brew-fonts projects spacemacs arcanist farc projects/z .fzf ## Set up a new development machine

.PHONY: brew
brew: ## Install the Homebrew package manager
ifeq ($(wildcard /usr/local/bin/brew),)
	/usr/bin/ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew tap caskroom/fonts
endif

.PHONY: brew-fonts
brew-fonts: brew ## Use Homebrew to install some fonts
	brew cask install \
		font-inconsolata-for-powerline \
		font-source-code-pro-for-powerline \
		font-fira-code \
		font-hack \
		font-noto-emoji \
		font-noto-color-emoji \
		font-noto-sans \
		font-noto-serif

.PHONY: brew-pkg
brew-pkg: brew ## Install a selection of Homebrew packages
	brew install \
		coreutils \
		git \
		zsh \
		tmux \
		aspell \
		trash \
		jq \
		htop-osx \
		vim \
		neovim/neovim/neovim \
		the_silver_searcher \
		ranger \
		curl \
		go
	brew cask install hyper

.PHONY: spacemacs
spacemacs: brew-pkg .notes .emacs.d ## Install the Spacemacs emacs distribution
	brew tap d12frosted/emacs-plus
	brew install emacs-plus
	brew linkapps emacs-plus
ifeq ($(wildcard bin/emacsclient),)
	mkdir -p bin
	ln -s /usr/local/Cellar/emacs-plus/24.5/bin/emacsclient bin/emacsclient
endif

.emacs.d:
	git clone https://github.com/syl20bnr/spacemacs .emacs.d

.PHONY: farc
farc: brew-pkg projects ## Install farc, a sane workflow tool for Phabricator
	git clone gitolite@code.uber.internal:personal/xyzzy/farc ~/projects/farc
	ln -s ~/projects/farc/farc ~/bin/farc

.PHONY: go-pkg
go-pkg: brew-pkg ## Install commonly-used Go language libraries
# TODO: automate replacing system Go.
	go get -u \
		github.com/golang/lint/golint \
		golang.org/x/tools/cmd/... \
		github.com/google/godepq \
		github.com/nsf/gocode \
		github.com/rogpeppe/godef

projects: ## Create directories for code projects and binaries
	mkdir -p ~/bin
	mkdir -p ~/projects
	mkdir -p ~/projects/uber

.notes: ## Create a convenient symlink to my Dropbox notes
	mkdir -p 'Dropbox/notes'
	ln -s 'Dropbox/notes' .notes

.fzf: brew-pkg ## Install the fzf fuzzy-finder
	git clone https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install

projects/z: brew-pkg projects ## Install the z auto-jumper
	git clone https://github.com/rupa/z ~/projects/z
