.DEFAULT_GOAL := help

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'

.PHONY: all
all: brew-pkg go-pkg py-pkg brew-fonts projects projects/z ## Set up a new development machine

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
		font-fira-mono \
		font-hack \
		font-noto-emoji \
		font-noto-color-emoji \
		font-noto-sans \
		font-noto-serif

.PHONY: brew-pkg
brew-pkg: brew ## Install a selection of Homebrew packages
	brew upgrade
	brew install \
		coreutils \
		git \
		zsh \
		tmux \
		ranger \
		vim \
		neovim/neovim/neovim \
		the_silver_searcher \
		ripgrep \
		fzf \
		aspell \
		jsonlint \
		proselint \
		jq \
		htop-osx \
		curl \
		go \
		python \
		python3

.PHONY: go-pkg
go-pkg: brew-pkg ## Install commonly-used Go language libraries
	go get -u \
		github.com/golang/lint/golint \
		golang.org/x/tools/cmd/... \
		github.com/google/godepq \
		github.com/alecthomas/gometalinter \
		github.com/mdempsky/maligned \
		github.com/nsf/gocode \
		github.com/rogpeppe/godef \
		honnef.co/go/tools/cmd/...

.PHONY: py-pkg
py-pkg: brew-pkg ## Install commonly-used Python language libraries
	pip2 install --user -U neovim yapf
	pip3 install --user -U neovim yapf

projects: ## Create directories for code projects and binaries
	mkdir -p ~/bin
	mkdir -p ~/projects
	mkdir -p ~/projects/uber

projects/z: brew-pkg projects ## Install the z auto-jumper
	git clone https://github.com/rupa/z ~/projects/z
