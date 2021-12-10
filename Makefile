# See https://tech.davis-hansson.com/p/make/
SHELL := bash
.DELETE_ON_ERROR:
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

GO_VERSION := 1.17.5

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'


.PHONY: todo
todo:: ## List tasks not managed by this Makefile
	$(info Create an SSH key and upload it to GitHub.)
	$(info Install Roam Research.)
	$(info Initialize gmailctl.)

.PHONY: setup
setup:: sys-pkg rust-pkg ## Set up a development environment
	$(MAKE) go-pkg py-pkg
	$(MAKE) projects/z/z.sh
	$(MAKE) .tmux/plugins/tpm/tpm

.PHONY: sys-pkg
sys-pkg:: /usr/local/bin/brew .cargo/bin/cargo
	brew tap cantino/mcfly
	brew tap homebrew/cask
	brew tap homebrew/cask-fonts
	brew install $$(cat brewpkg.txt)
	$$(brew --prefix)/opt/fzf/install --no-fish --no-update-rc --xdg --key-bindings --completion
	brew install --cask $$(cat caskpkg.txt)
	.cargo/bin/rustup default stable

.PHONY: update
update:: /usr/local/bin/brew ## Update all managed packages and tools
	@# It's not worth sorting out which of these can run in parallel with
	@# system package updates.
	brew update
	brew upgrade
	$(MAKE) rust-pkg go-pkg py-pkg
	rm -rf projects/z .tmux/plugins
	$(MAKE) projects/z/z.sh
	$(MAKE) .tmux/plugins/tpm/tpm
	nvim +PlugUpgrade +PlugUpdate +qa
	gmailctl apply

.PHONY: clean
clean:: ## Partially clean up installed resources
	brew cleanup
	rm -f $(GOPATH)/bin/go1.*
	rm -rf projects/z
	rm -rf .tmux/plugins
	nvim +PlugClean +qa

.PHONY: go-pkg
go-pkg:
	GOPATH=$(HOME) go install golang.org/dl/go$(GO_VERSION)@latest
	[[ -d $(HOME)/sdk/go$(GO_VERSION) ]] || bin/go$(GO_VERSION) download
	GOPATH=$(HOME) bin/go$(GO_VERSION) get -u $$(cat gopkg.txt)

.PHONY: py-pkg
py-pkg:
	python3 -m pip install -U $$(cat pypkg.txt)

.PHONY: rust-pkg
rust-pkg: .cargo/bin/cargo
	.cargo/bin/rustup update
	.cargo/bin/rustup component add rls-preview rust-analysis rust-src
	.cargo/bin/cargo install --locked $$(cat rustpkg.txt)

/usr/local/bin/brew:
	/usr/bin/ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

.cargo/bin/cargo:
	curl https://sh.rustup.rs -sSf | sh

projects/z/z.sh:
	rm -rf $(@D)
	git clone https://github.com/rupa/z ~/projects/z

.tmux/plugins/tpm/tpm:
	mkdir -p .tmux/plugins/tpm
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Add to double-colon rules above in a private, work-specific Makefile.
-include Dropbox/work.mk
