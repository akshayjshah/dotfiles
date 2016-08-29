.DEFAULT_GOAL := help

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'

.PHONY: all
all: deb-base deb-pkg fasd farc go-pkg .notes ## Set up a new development machine

.PHONY: deb-base
deb-base: ## Install Debian packages required to build or install other tools
	sudo apt-get install build-essential \
		git \
		apt-listbugs

.PHONY: deb-pkg
deb-pkg: ## Install a variety of useful Debian packages
	sudo apt-get install zsh \
		jq \
		vim-nox \
		emacs24-nox \
		silversearcher-ag \
		ranger \
		golang-1.7 \
		hugo \
		sassc \
		curl \
		nautilus-dropbox \
		xclip

.PHONY: fasd
fasd: deb-base projects ## Install fasd, a command-line productivity booster
	git clone https://github.com/clvv/fasd.git ~/projects/fasd
	@echo "Run `make install` in ~/projects/fasd."

.PHONY: farc
farc: deb-base projects ## Install farc, a sane workflow tool for Phabricator
	git clone gitolite@code.uber.internal:personal/xyzzy/farc ~/projects/farc
	ln -s ~/projects/farc/farc ~/bin/farc

.PHONY: arcanist
arcanist: deb-base projects ## Install arcanist, a completely insane tool for working with Phabricator
	sudo apt-get install php curl7.0-php
	git clone git@github.com:uber/libphutil.git ~/projects/uber/libphutil
	git clone git@github.com:uber/arcanist.git ~/projects/uber/arcanist
	ln -sfv ~/projects/uber/arcanist/bin/arc ~/bin/arc
	~/bin/arc install-certificate

.PHONY: go-pkg
go-pkg: deb-pkg  ## Install commonly-used Go language libraries
	go get -u \
		github.com/golang/lint/golint \
		golang.org/x/... \
		github.com/google/godepq \
		godepq.com/nsf/gocode \
		github.com/rogpeppe/godef

.PHONY: neovim
neovim: deb-base ## Install neovim and vim-plug
	@echo "Neovim is only available in the experimental repos."
# 	sudo apt-get install -t experimental neovim python3-neovim
# ifeq ($(wildcard .config/nvim/autoload/plug.vim),)
# 	curl -fLo .config/nvim/autoload/plug.vim --create-dirs "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
# endif

.notes:
	mkdir -p 'Dropbox/notes'
	ln -s 'Dropbox/notes' .notes

projects:
	mkdir -p ~/bin
	mkdir -p ~/projects
	mkdir -p ~/projects/uber
