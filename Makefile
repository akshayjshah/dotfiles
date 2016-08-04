.DEFAULT_GOAL := help

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'

.PHONY: all
all: go python neovim text-tools ranger zsh fzf blog fix-mac .notes ## Set up a new development machine

.PHONY: text-tools
text-tools: brew ## Install GNU sed and ag
	brew install gnu-sed
	brew install the_silver_searcher

.PHONY: go
go: brew git ## Install Go and a variety of useful packages
	brew install go
	go get -u \
		github.com/golang/lint/golint \
		golang.org/x/tools/cmd/benchcmp \
		golang.org/x/tools/cmd/cover \
		golang.org/x/tools/cmd/godoc \
		golang.org/x/tools/cmd/goimports \
		golang.org/x/tools/cmd/present \
		github.com/google/godepq

.PHONY: python
python: ## Install python and virtualenvwrapper
	brew install python
	brew install pyenv-virtualenvwrapper

.PHONY: ranger
ranger: brew ## Install ranger
	brew install ranger

.PHONY: fzf
fzf: brew ## Install fzf
	brew install fzf

.PHONY: neovim
neovim: brew python ## Install neovim and vim-plug
	brew install neovim/neovim/neovim --env=std
	pip install -u neovim
ifeq ($(wildcard .config/nvim/autoload/plug.vim),)
	curl -fLo .config/nvim/autoload/plug.vim --create-dirs "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
endif

.PHONY: zsh
zsh: brew ## Install zsh
	brew install zsh

.PHONY: blog
blog: brew ## Install Hugo and sassc
	brew install hugo
	brew install sassc

.PHONY: git
git: brew ## Install git (from Homebrew)
	brew install git

.PHONY: curl
curl: brew ## Install cURL
	brew install curl

.PHONY: brew
brew: ## Install and update Homebrew
	brew -h > /dev/null || /usr/bin/ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew update

.notes:
	mkdir -p 'Dropbox (Personal)/notes'
	ln -s 'Dropbox (Personal)/notes' .notes

fix-mac: ## Reconfigure some MacOS settings
	# Enable press-and-hold for key repeat.
	defaults write -g ApplePressAndHoldEnabled -bool false
