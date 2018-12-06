.DEFAULT_GOAL := help
GO_VERSION := 1.11.2
NEOVIM_VERSION := v0.3.1
RELEASE = $(shell lsb_release -c -s)

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'

.PHONY: todo
todo:: ## List tasks not managed by this Makefile
	@echo "chsh -s /usr/bin/zsh"
	@echo "Create an SSH key and upload it to GitHub"

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
	echo "deb https://packages.cloud.google.com/apt cloud-sdk-$(RELEASE) main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
	curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
	sudo apt update
	sudo apt install --assume-yes \
		aspell \
		bazel \
		cmake \
		fonts-powerline \
		gnome-terminal \
		google-cloud-sdk \
		graphviz \
		htop \
		jq \
		keychain \
		lsof \
		openjdk-8-jdk \
		python \
		python-pip \
		python3 \
		python3-pip \
		racket \
		ranger \
		redis-server \
		ruby \
		shellcheck \
		sqlite3 \
		tig \
		tmux \
		wget \
		xclip \
		zlib1g-dev \
		zsh
	sudo cp .config/gnome-terminal-crostini.desktop /usr/share/applications/gnome-terminal-crostini.desktop
	sudo chown root:root /usr/share/applications/gnome-terminal-crostini.desktop
	sudo chmod 644 /usr/share/applications/gnome-terminal-crostini.desktop
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

.PHONY: update
update:: ## Update all managed packages and tools
	sudo apt upgrade --assume-yes
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
	@# https://github.com/neovim/neovim/wiki/Building-Neovim#build-prerequisites
	sudo apt install --assume-yes ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip
	if [ ! -d projects/neovim ]; \
		then mkdir -p projects && git clone https://github.com/neovim/neovim.git projects/neovim; \
		fi
	cd projects/neovim && git fetch --tags origin && git checkout $(NEOVIM_VERSION)
	cd projects/neovim && make
	cd projects/neovim && sudo make install

.PHONY: go-pkg
go-pkg:
	eval `GIMME_GO_VERSION=$(GO_VERSION) bin/gimme` && GOPATH=$(HOME) go get -u \
		golang.org/x/lint/golint \
		github.com/golang/dep/cmd/dep \
		golang.org/x/tools/cmd/... \
		honnef.co/go/tools/cmd/... \
		github.com/bazelbuild/buildtools/buildozer \
		github.com/sourcegraph/go-langserver

.PHONY: py-pkg
py-pkg:
	python -m pip install -U pip neovim virtualenv
	python3 -m pip install -U pip neovim
	# Need to build Python 3 from source.
	# python3 -m pip install -U pip \
	#	asciinema \
	#	black \
	#	flit \
	#	neovim \
	#	poetry \
	#	pyls-black \
	#	pyls-isort \
	#	"python-language-server[pycodestyle, pydocstyle, pyflakes, rope]" \
	#	git-fame \
	#	pipenv \
	#	pyre-check

.cargo/bin/cargo:
	curl https://sh.rustup.rs -sSf | sh

.PHONY: rust-pkg
rust-pkg: .cargo/bin/cargo
	PATH=.cargo/bin:$(PATH) rustup update
	PATH=.cargo/bin:$(PATH) rustup component add rls-preview rust-analysis rust-src
	PATH=.cargo/bin:$(PATH) cargo install --force \
		dutree \
		fastmod \
		ripgrep \
		exa \
		fd-find

-include workdots/work.mk
