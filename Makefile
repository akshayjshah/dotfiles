.DEFAULT_GOAL := help

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'

.PHONY: all
all: projects deb-pkg arcanist farc projects/z .fzf .notes .emacs.d ## Set up a new development machine, sans Go packages.

.PHONY: deb-base
deb-base: ## Install Debian packages required to build or install other tools
	sudo apt-get install build-essential \
		git \
		apt-listbugs

.PHONY: deb-pkg
deb-pkg: deb-base ## Install a variety of useful Debian packages
	sudo apt-get install zsh \
		tmux \
		jq \
		htop \
		vim-nox \
		emacs24-nox \
		silversearcher-ag \
		ranger \
		tree \
		curl \
		nautilus-dropbox \
		xclip \
		fonts-roboto \
		yui-compressor \
		lastpass-cli

.PHONY: farc
farc: deb-base projects ## Install farc, a sane workflow tool for Phabricator
	git clone gitolite@code.uber.internal:personal/xyzzy/farc ~/projects/farc
	ln -s ~/projects/farc/farc ~/bin/farc

.PHONY: arcanist
arcanist: deb-base projects ## Install arcanist, a completely insane tool for working with Phabricator
	sudo apt-get install php5 php5-curl
	git clone git@github.com:uber/libphutil.git ~/projects/uber/libphutil
	git clone git@github.com:uber/arcanist.git ~/projects/uber/arcanist
	ln -sfv ~/projects/uber/arcanist/bin/arc ~/bin/arc
	~/bin/arc install-certificate

.PHONY: go-pkg
go-pkg: ## Install commonly-used Go language libraries
# TODO: automate replacing system Go.
	go get -u \
		github.com/golang/lint/golint \
		golang.org/x/... \
		github.com/google/godepq \
		github.com/niemeyer/godeb/cmd/godeb \
		github.com/nsf/gocode \
		github.com/rogpeppe/godef \
		github.com/spf13/hugo \
		github.com/wellington/wellington/wt

projects:  ## Create a directory for code projects
	mkdir -p ~/bin
	mkdir -p ~/projects
	mkdir -p ~/projects/uber

.notes: ## Create a convenient symlink to my Dropbox notes
	mkdir -p 'Dropbox/notes'
	ln -s 'Dropbox/notes' .notes

.fzf: deb-base ## Install the fzf fuzzy-finder
	git clone https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install

projects/z: deb-base projects ## Install the z auto-jumper
	git clone https://github.com/rupa/z ~/projects/z

.emacs.d: deb-base ## Initialize spacemacs
	git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
