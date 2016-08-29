.DEFAULT_GOAL := help

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'

.PHONY: all
all: deb-base deb-pkg fasd go-pkg .notes ## Set up a new development machine

.PHONY: deb-base
deb-base: ## Install Debian packages required to build or install other tools
	sudo apt-get install build-essential \
		git \
		apt-listbugs

.PHONY: deb-pkg
deb-pkg:  ## Install a variety of useful Debian packages
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
fasd: deb-base
	mkdir -p ~/projects
	git clone https://github.com/clvv/fasd.git ~/projects/fasd
	@echo "Run `make install` in ~/projects/fasd."

.PHONY: go-pkg
go-pkg: deb-pkg
	go get -u \
		github.com/golang/lint/golint \
		golang.org/x/... \
		github.com/google/github \
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
