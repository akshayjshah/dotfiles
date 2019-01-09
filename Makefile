.DEFAULT_GOAL := help
GO_VERSION := 1.11.4

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'

.PHONY: todo
todo:: ## List tasks not managed by this Makefile
	$(info Create an SSH key and upload it to GitHub)

.PHONY: setup
setup:: /usr/local/bin/brew  ## Set up a development environment
	brew tap homebrew/cask
	brew tap homebrew/cask-fonts
	brew tap homebrew/cask-versions
	brew tap bazelbuild/tap
	brew tap-pin bazelbuild/tap
	brew tap facebook/fb
	brew install \
		aspell \
		bazelbuild/tap/bazel \
		cmake \
		direnv \
		exa \
		facebook/fb/buck \
		fd \
		git \
		git-lfs \
		graphviz \
		homebrew/cask/alacritty \
		homebrew/cask/google-cloud-sdk \
		homebrew/cask/racket \
		homebrew/cask-fonts/font-powerline-symbols \
		homebrew/cask-fonts/font-fira-mono-for-powerline \
		homebrew/cask-versions/java8 \
		htop \
		jq \
		keychain \
		libgit2 \
		lsof \
		python \
		python@2 \
		neovim \
		ranger \
		redis \
		ripgrep \
		ruby \
		shellcheck \
		sqlite3 \
		tig \
		tmux \
		tree \
		watchman \
		wget \
		zsh
	$(MAKE) bin/diff-so-fancy  # nicer git diffs
	$(MAKE) projects/z/z.sh  # z auto-jumper
	$(MAKE) bin/gimme  # manage Go compiler
	~/bin/gimme $(GO_VERSION)
	$(MAKE) n/bin/n  # manage Node.js runtimes
	$(MAKE) go-pkg
	$(MAKE) py-pkg
	$(MAKE) rust-pkg

.PHONY: update
update:: ## Update all managed packages and tools
	brew update
	brew upgrade
	n-update -y
	@# It's not worth sorting out which of these can run in parallel with
	@# system package updates.
	rm -rf bin/gimme projects/z bin/diff-so-fancy
	$(MAKE) bin/gimme projects/z/z.sh bin/diff-so-fancy
	$(MAKE) go-pkg rust-pkg py-pkg
	nvim +PlugUpgrade +PlugUpdate +qa

/usr/local/bin/brew:
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

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

.cargo/bin/cargo:
	curl https://sh.rustup.rs -sSf | sh

.PHONY: go-pkg
go-pkg:
	eval `GIMME_GO_VERSION=$(GO_VERSION) bin/gimme` && GOPATH=$(HOME) go get -u \
		golang.org/x/lint/golint \
		github.com/golang/dep/cmd/dep \
		golang.org/x/tools/cmd/... \
		honnef.co/go/tools/cmd/... \
		github.com/bazelbuild/buildtools/buildozer

.PHONY: py-pkg
py-pkg:
	python -m pip install -U pip neovim virtualenv
	python3 -m pip install -U pip neovim
	python3 -m pip install -U pip \
		asciinema \
		black \
		flit \
		neovim \
		poetry \
		git-fame \
		pipenv \
		pyre-check

.PHONY: rust-pkg
rust-pkg: .cargo/bin/cargo
	PATH=.cargo/bin:$(PATH) rustup update
	PATH=.cargo/bin:$(PATH) rustup component add rls-preview rust-analysis rust-src

-include Dropbox/work.mk
