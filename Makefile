.DEFAULT_GOAL := help
GO_VERSION := 1.10.3

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'

.PHONY: todo
todo:: ## List tasks not managed by this Makefile
	@echo "Create an SSH key and upload it to GitHub"
	@echo "Chrome:\t\thttps://www.google.com/chrome/"
	@echo "Dropbox:\thttps://www.dropbox.com/install-linux"

.PHONY: setup
setup:: ## Set up a Debian development environment
	@# Required for further apt operations.
	sudo apt install --assume-yes \
		apt-transport-https \
		build-essential \
		ca-certificates \
		curl \
		software-properties-common
	echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
	curl -fsSL https://bazel.build/bazel-release.pub.gpg | sudo apt-key add -
	sudo add-apt-repository ppa:plt/racket
	sudo apt update
	sudo apt install --assume-yes \
		aspell \
		bazel \
		cmake \
		docker.io \
		docker-compose \
		fonts-powerline \
		gnome-tweak-tool \
		graphviz \
		htop \
		jq \
		keychain \
		openjdk-8-jdk \
		ppa-purge \
		python \
		python-pip \
		python3 \
		python3-pip \
		racket \
		ranger \
		redis \
		ruby \
		shellcheck \
		snapd \
		sqlite3 \
		tig \
		tmux \
		wget \
		xclip \
		zlib1g-dev \
		zsh
	sudo snap install --classic slack
	sudo snap install vscode --classic
	$(MAKE) bin/nvim
	$(MAKE) bin/diff-so-fancy  # nicer git diffs
	$(MAKE) bin/nova-gnome-terminal.sh  # script to install terminal color theme
	$(MAKE) projects/z/z.sh  # z auto-jumper
	$(MAKE) bin/gimme  # manage Go compiler
	$(MAKE) n/bin/n  # manage Node.js runtimes
	~/bin/gimme $(GO_VERSION)
	$(MAKE) go-pkg
	$(MAKE) py-pkg
	$(MAKE) rust-pkg
	$(MAKE) vscode

.PHONY: update
update:: ## Update all managed packages and tools
	sudo apt upgrade --assume-yes
	sudo snap refresh
	@# It's not worth sorting out which of these can run in parallel with
	@# system package updates.
	$(MAKE) bin/nvim
	$(MAKE) go-pkg
	$(MAKE) rust-pkg
	$(MAKE) py-pkg
	nvim +PlugUpgrade +PlugUpdate +qa

bin/gimme:
	mkdir -p ~/bin
	wget -O bin/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme
	chmod +x bin/gimme

projects/z/z.sh:
	mkdir -p ~/projects/z
	git clone https://github.com/rupa/z ~/projects/z

bin/diff-so-fancy:
	mkdir -p ~/bin
	wget -O bin/diff-so-fancy https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy
	chmod +x bin/diff-so-fancy

n/bin/n:
	curl -L https://git.io/n-install | bash

bin/nova-gnome-terminal.sh:
	mkdir -p ~/bin
	wget -O bin/nova-gnome-terminal.sh https://raw.githubusercontent.com/agarrharr/nova-gnome-terminal/master/build/install.sh
	chmod +x bin/nova-gnome-terminal.sh

.PHONY:bin/nvim
bin/nvim:
	curl -LO https://github.com/neovim/neovim/releases/download/v0.3.1/nvim.appimage && mv nvim.appimage $@ && chmod +x $@

.PHONY: go-pkg
go-pkg:
	eval `GIMME_GO_VERSION=$(GO_VERSION) bin/gimme` && GOPATH=$(HOME) go get -u \
		golang.org/x/lint/golint \
		github.com/golang/dep/cmd/dep \
		golang.org/x/tools/cmd/... \
		github.com/google/godepq \
		honnef.co/go/tools/cmd/... \
		github.com/mgechev/revive \
		github.com/akshayjshah/hardhat

.PHONY: py-pkg
py-pkg:
	python -m pip install --user -U pip neovim virtualenv
	python3 -m pip install --user -U pip asciinema black flit neovim poetry git-fame neovim pipenv pyre-check yapf

.cargo/bin/cargo:
	curl https://sh.rustup.rs -sSf | sh

.PHONY: rust-pkg
rust-pkg: .cargo/bin/cargo
	PATH=.cargo/bin:$(PATH) rustup update
	PATH=.cargo/bin:$(PATH) cargo install --force \
		dutree \
		fastmod \
		ripgrep \
		exa \
		fd-find

.PHONY: vscode
vscode:
	sudo apt install gconf-service
	curl -L0 https://go.microsoft.com/fwlink/?LinkID=760868 --output vscode.deb
	sudo dpkg -i vscode.deb
	sudo apt --fix-broken install # install dependencies
	rm vscode.deb || true

-include Dropbox/work.mk
