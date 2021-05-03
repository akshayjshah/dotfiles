# See https://tech.davis-hansson.com/p/make/
SHELL := bash
.DELETE_ON_ERROR:
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

GO_VERSION := 1.16.3

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'


.PHONY: todo
todo:: ## List tasks not managed by this Makefile
	$(info Create an SSH key and upload it to GitHub.)
	$(info Change Windows Terminal starting dir: https://docs.microsoft.com/en-us/windows/terminal/troubleshooting#set-your-wsl-distribution-to-start-in-the-home--directory-when-launched.)
	$(info Initialize gmailctl.)
	$(info Install Nu shell?)
	$(info On Ubuntu 20.10 and later, install exa from apt.)

.PHONY: setup
setup:: ## Set up a development environment
	# For Github CLI
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
	sudo apt-add-repository https://cli.github.com/packages
	sudo apt update -y
	# Prerequisites for other tools
	sudo apt install -y \
		build-essential \
		git \
		software-properties-common
	# Development tools
	sudo apt install -y \
		aspell \
		bash \
		curl \
		direnv \
		fd-find \
		gh \
		git-lfs \
		graphviz \
		htop \
		jq \
		lsof \
		protobuf-compiler \
		python2 \
		python3 \
		python3-pip \
		ranger \
		ripgrep \
		shellcheck \
		sqlite3 \
		tig \
		tmux \
		tree \
		vim-nox \
		watchman \
		wget \
		xclip \
		zsh
	$(MAKE) bin/diff-so-fancy  # nicer git diffs
	$(MAKE) bin/nvim # Neovim
	$(MAKE) projects/z/z.sh  # z auto-jumper
	$(MAKE) .tmux/plugins/tpm/tpm # tmux plugin manager
	$(MAKE) bin/gimme  # manage Go compiler
	~/bin/gimme $(GO_VERSION)
	$(MAKE) .dotnet/dotnet # get current .NET
	$(MAKE) n/bin/n  # manage Node.js runtimes
	$(MAKE) go-pkg
	$(MAKE) py-pkg
	$(MAKE) rust-pkg

.PHONY: update
update:: ## Update all managed packages and tools
	sudo apt update -y
	sudo apt upgrade -y
	n-update -y
	@# It's not worth sorting out which of these can run in parallel with
	@# system package updates.
	rm -rf bin/gimme bin/nvim projects/z bin/diff-so-fancy .tmux/plugins .bin/install-dotnet.sh
	$(MAKE) bin/gimme bin/nvim projects/z/z.sh bin/diff-so-fancy .tmux/plugins/tpm/tpm .dotnet/dotnet
	$(MAKE) go-pkg rust-pkg py-pkg
	nvim +PlugUpgrade +PlugUpdate +qa
	gmailctl apply

bin/gimme:
	mkdir -p $(@D)
	rm -f $@
	wget -q -O $@ https://raw.githubusercontent.com/travis-ci/gimme/master/gimme
	chmod +x $@

bin/dotnet-install.sh:
	mkdir -p $(@D)
	rm -f $@
	wget -q -O $@ https://dot.net/v1/dotnet-install.sh
	chmod +x $@

.dotnet/dotnet: bin/dotnet-install.sh
	~/bin/dotnet-install.sh -c Current

bin/nvim:
	mkdir -p $(@D)
	rm -f $@
	wget -q -O $@ https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
	chmod u+x $@

projects/z/z.sh:
	rm -rf $(@D)
	git clone https://github.com/rupa/z ~/projects/z

bin/diff-so-fancy:
	mkdir -p $(@D)
	rm -f $@
	wget -q -O $@ https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy
	chmod +x $@

n/bin/n:
	curl -L https://git.io/n-install | bash

.cargo/bin/cargo:
	curl https://sh.rustup.rs -sSf | sh

.tmux/plugins/tpm/tpm:
	rm -rf $(@D)
	mkdir -p $(@D)
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

.PHONY: go-pkg
go-pkg:
	eval `GIMME_GO_VERSION=$(GO_VERSION) bin/gimme` && GOPATH=$(HOME) go get -u \
		golang.org/x/lint/golint \
		github.com/boyter/scc/ \
		golang.org/x/tools/cmd/... \
		mvdan.cc/sh/cmd/shfmt \
		github.com/abhinav/restack/cmd/restack \
		github.com/mbrt/gmailctl/cmd/gmailctl \
		github.com/google/go-jsonnet/cmd/... \
		google.golang.org/protobuf/cmd/protoc-gen-go \
		google.golang.org/grpc/cmd/protoc-gen-go-grpc

.PHONY: py-pkg
py-pkg:
	python3 -m pip install -U pip
	python3 -m pip install -U \
		asciinema \
		black \
		neovim \
		git-fame \
		pipenv

.PHONY: rust-pkg
rust-pkg: .cargo/bin/cargo
	PATH=".cargo/bin:$(PATH)" rustup update
	PATH=".cargo/bin:$(PATH)" rustup component add rls-preview rust-analysis rust-src
	~/.cargo/bin/cargo install exa

# Add to double-colon rules above in a private, work-specific Makefile.
-include /mnt/c/Users/aksha/Dropbox/work.mk
