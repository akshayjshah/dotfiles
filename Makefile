.DEFAULT_GOAL := help
GO_VERSION := 1.14.4

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'

.PHONY: todo
todo:: ## List tasks not managed by this Makefile
	$(info Create an SSH key and upload it to GitHub)
	$(info Nord Slack theme: https://github.com/arcticicestudio/nord-slack)

.PHONY: setup
setup:: /usr/local/bin/brew  ## Set up a development environment
	brew tap homebrew/cask || true
	brew tap homebrew/cask-fonts || true
	brew tap homebrew/cask-versions || true
	brew install \
		aspell \
		bash \
		cocoapods \
		curl \
		direnv \
		fd \
		git \
		github/gh/gh \
		git-lfs \
		gnu-sed \
		graphviz \
		homebrew/cask/alfred \
		homebrew/cask/google-chrome \
		homebrew/cask/google-cloud-sdk \
		homebrew/cask/google-drive-file-stream \
		homebrew/cask/hammerspoon \
		homebrew/cask/slack \
		homebrew/cask/visual-studio-code \
		homebrew/cask/zoomus \
		homebrew/cask-fonts/font-powerline-symbols \
		homebrew/cask-fonts/font-fira-mono-for-powerline \
		htop \
		jsonnet \
		jq \
		lsof \
		mint \
		nushell \
		protobuf \
		python \
		python@2 \
		neovim \
		ranger \
		reattach-to-user-namespace \
		redis \
		ripgrep \
		shellcheck \
		sqlite3 \
		tig \
		tmux \
		tree \
		watchman \
		wget \
		zsh || true
	defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
	$(MAKE) bin/diff-so-fancy  # nicer git diffs
	$(MAKE) projects/z/z.sh  # z auto-jumper
	$(MAKE) projects/nord/Nord.terminal
	$(MAKE) .tmux/plugins/tpm/tpm
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
	rm -rf bin/gimme projects/z bin/diff-so-fancy projects/nord/Nord.terminal .tmux/plugins
	$(MAKE) bin/gimme projects/z/z.sh bin/diff-so-fancy projects/nord/Nord.terminal .tmux/plugins/tpm/tpm
	$(MAKE) go-pkg rust-pkg py-pkg
	nvim +PlugUpgrade +PlugUpdate +qa
	gmailctl apply

/usr/local/bin/brew:
	/usr/bin/ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

bin/gimme:
	mkdir -p ~/bin
	wget -O bin/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme
	chmod +x bin/gimme

projects/z/z.sh:
	mkdir -p ~/projects/z
	git clone https://github.com/rupa/z ~/projects/z

projects/nord/Nord.terminal:
	mkdir -p ~/projects/nord
	wget -O ~/projects/nord/Nord.terminal https://raw.githubusercontent.com/arcticicestudio/nord-terminal-app/develop/src/xml/Nord.terminal

bin/diff-so-fancy:
	mkdir -p ~/bin
	wget -O bin/diff-so-fancy https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy
	chmod +x bin/diff-so-fancy

n/bin/n:
	curl -L https://git.io/n-install | bash

.cargo/bin/cargo:
	curl https://sh.rustup.rs -sSf | sh

.tmux/plugins/tpm/tpm:
	mkdir -p .tmux/plugins/tpm
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

.PHONY: go-pkg
go-pkg:
	eval `GIMME_GO_VERSION=$(GO_VERSION) bin/gimme` && GOPATH=$(HOME) go get -u \
		golang.org/x/lint/golint \
		github.com/boyter/scc/ \
		golang.org/x/tools/cmd/... \
		mvdan.cc/sh/cmd/shfmt \
		github.com/abhinav/restack/cmd/restack \
		github.com/mbrt/gmailctl/cmd/gmailctl

.PHONY: py-pkg
py-pkg:
	python -m pip install -U pip neovim virtualenv
	python3 -m pip install -U pip neovim
	python3 -m pip install -U pip \
		asciinema \
		black \
		neovim \
		git-fame \
		pipenv \
		pyre-check \
		tqdm

.PHONY: rust-pkg
rust-pkg: .cargo/bin/cargo
	PATH=.cargo/bin:$(PATH) rustup update
	PATH=.cargo/bin:$(PATH) rustup component add rls-preview rust-analysis rust-src

-include Dropbox/work.mk
