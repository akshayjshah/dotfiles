.DEFAULT_GOAL := help

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'

.PHONY: go-pkg
go-pkg: ## Install commonly-used Go language libraries
	go get -u \
		github.com/golang/lint/golint \
		golang.org/x/tools/cmd/... \
		github.com/google/godepq \
		github.com/alecthomas/gometalinter \
		honnef.co/go/tools/cmd/... \
		github.com/akshayjshah/hardhat

.PHONY: py-pkg
py-pkg: ## Install commonly-used Python language libraries
	pip2 install --user -U neovim yapf virtualenv
	pip3 install --user -U neovim yapf virtualenv

.PHONY: cargo
cargo: .cargo/bin/cargo ## Install cargo, the Rust package manager

.cargo/bin/cargo:
	curl https://sh.rustup.rs -sSf | sh

.PHONY: rust-pkg
rust-pkg: cargo ## Install commonly-used Rust language libraries
	cargo install \
		ripgrep \
		exa \
		fd-find

.PHONY: fedora
fedora: ## Install Fedora system packages & FlatPaks
	sudo dnf install \
		aspell	\
		cmake \
		curl \
		gcc \
		gcc-c++ \
		git \
		gnome-tweak-tool \
		htop \
		jq \
		keychain \
		make \
		mozilla-fira-mono-fonts \
		mozilla-fira-sans-fonts \
		neovim \
		powerline-fonts \
		python2 \
		python2-neovim \
		python3 \
		python3-neovim \
		ranger \
		tig \
		tmux \
		vim-enhanced \
		wget \
		xclip \
		zlib-devel \
		zsh
	sudo flatpak remote-add --if-not-exists --from gnome https://sdk.gnome.org/gnome.flatpakrepo
	sudo flatpak remote-add --if-not-exists --from org.mozilla.FirefoxRepo https://firefox-flatpak.mojefedora.cz/org.mozilla.FirefoxRepo.flatpakrepo
	sudo flatpak install org.mozilla.FirefoxRepo org.mozilla.FirefoxDevEdition

.PHONY: update-fedora
update-fedora: ## Update Fedora system packages & FlatPaks
	sudo dnf upgrade
	sudo flatpak update

.PHONY: dirs
dirs: projects bin projects/uber ## Create directories for code projects and binaries

bin:
	mkdir -p ~/bin

.PHONY: gimme
gimme: bin/gimme ## Install gimme, a Go version manager

bin/gimme: bin
	wget -O bin/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme
	chmod +x bin/gimme

projects:
	mkdir -p ~/projects

projects/uber:
	mkdir -p ~/projects/uber

.PHONY: z
z: projects ## Install the z auto-jumper
	mkdir -p ~/projects/z
	git clone https://github.com/rupa/z ~/projects/z

.PHONY: diff-so-fancy
diff-so-fancy: bin/diff-so-fancy ## Install diff-so-fancy, a git diff prettifier

bin/diff-so-fancy: bin
	wget -O bin/diff-so-fancy https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy
	chmod +x bin/diff-so-fancy

.PHONY: nvm
nvm: .nvm/nvm.sh ## Install the node.js version manager

.nvm/nvm.sh:
	wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash

.PHONY: nova
nova: bin/nova-gnome-terminal.sh ## Install a script to add Nova colors to a GNOME Terminal profile
bin/nova-gnome-terminal.sh:
	wget -O bin/nova-gnome-terminal.sh https://raw.githubusercontent.com/agarrharr/nova-gnome-terminal/master/build/install.sh
	chmod +x bin/nova-gnome-terminal.sh

.PHONY: fira-powerline
fira-powerline: .fonts/fura-mono-regular-powerline.otf ## Install a Powerline-patched Fira Mono font

.fonts/fura-mono-regular-powerline.otf:
	mkdir -p .fonts
	wget -O .fonts/fura-mono-regular-powerline.otf https://github.com/powerline/fonts/raw/master/FiraMono/FuraMono-Regular%20Powerline.otf
	fc-cache -v
