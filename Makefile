.DEFAULT_GOAL := help

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'

.PHONY: all
all: go python spacemacs text-tools ranger zsh fzf blog ## Set up a new development machine

.PHONY: spacemacs
spacemacs: brew .emacs.d ## Install spacemacs
ifeq ($(wildcard .emacs.d/.*),)
	git clone https://github.com/syl20bnr/spacemacs .emacs.d
endif
	brew install aspell
	brew install coreutils
	brew install trash
	brew tap d12frosted/emacs-plus
	brew install emacs-plus --with-cocoa --with-gnutls --with-librsvg --with-imagemagick --with-spacemacs-icon
	brew linkapps
	mkdir -p bin
	# Homebrew doesn't install the emacs-plus binaries anywhere useful.
	ln -s /usr/local/Cellar/emacs-plus/24.5/bin/emacsclient bin/emacsclient

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
		golang.org/x/tools/cmd/callgraph \
		golang.org/x/tools/cmd/cover \
		golang.org/x/tools/cmd/eg \
		golang.org/x/tools/cmd/godoc \
		golang.org/x/tools/cmd/goimports \
		golang.org/x/tools/cmd/gomvpkg \
		golang.org/x/tools/cmd/gorename \
		golang.org/x/tools/cmd/oracle \
		golang.org/x/tools/cmd/present \
		golang.org/x/tools/cmd/guru \
		github.com/kisielk/errcheck \
		github.com/lukehoban/go-outline \
		github.com/newhook/go-symbols \
		github.com/nsf/gocode \
		github.com/rogpeppe/godef \
		github.com/tpng/gopkgs

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
