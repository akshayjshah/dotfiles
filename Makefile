# See https://tech.davis-hansson.com/p/make/
SHELL := bash
.DELETE_ON_ERROR:
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-print-directory

export GOPATH := $(HOME)
export GOTOOLCHAIN := go1.22.1+auto

ifeq ($(shell uname -m), arm64)
	HOMEBREW=/opt/homebrew/bin/brew
else
	HOMEBREW=/usr/local/bin/brew
endif

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'

.PHONY: todo
todo:: ## List tasks not managed by this Makefile
	$(info Create an SSH key and upload it to GitHub.)
	$(info Install Zoom.)
	$(info Initialize gmailctl.)

.PHONY: setup
setup:: sys-pkg ## Set up a development environment
	$(MAKE) rust-pkg go-pkg py-pkg
	$(MAKE) .tmux/plugins/tpm/tpm

.PHONY: sys-pkg
sys-pkg:: $(HOMEBREW) .cargo/bin/cargo
	$(HOMEBREW) tap cantino/mcfly
	$(HOMEBREW) tap homebrew/cask
	$(HOMEBREW) tap homebrew/cask-fonts
	$(HOMEBREW) tap homebrew/cask-versions
	$(HOMEBREW) tap helix-editor/helix
	$(HOMEBREW) install $$(cat brewpkg.txt)
	$$($(HOMEBREW) --prefix)/opt/fzf/install --no-fish --no-update-rc --xdg --key-bindings --completion
	$(HOMEBREW) install --cask $$(cat caskpkg.txt)
	.cargo/bin/rustup default stable
	gcloud components install gke-gcloud-auth-plugin

.PHONY: update
update:: $(HOMEBREW) ## Update all managed packages and tools
	@# It's not worth sorting out which of these can run in parallel with
	@# system package updates.
	$(HOMEBREW) update
	$(HOMEBREW) upgrade
	$(MAKE) rust-pkg go-pkg py-pkg
	rm -rf projects/z .tmux/plugins
	$(MAKE) .tmux/plugins/tpm/tpm
	gcloud components update
	nvim +PlugUpgrade +PlugUpdate +qa
	gh extension upgrade --all
	gmailctl apply

.PHONY: clean
clean:: ## Partially clean up installed resources
	$(HOMEBREW) cleanup
	rm -rf projects/z
	rm -rf .tmux/plugins
	nvim +PlugClean +qa

.PHONY: go-pkg
go-pkg:
	go build -o bin/gofmt cmd/gofmt
	@# From Go project.
	go install golang.org/x/perf/cmd/benchstat@latest
	go install golang.org/x/pkgsite/cmd/pkgsite@latest
	go install golang.org/x/review/git-codereview@latest
	go install \
		golang.org/x/tools/cmd/goimports@latest \
		golang.org/x/tools/cmd/gorename@latest \
		golang.org/x/tools/cmd/stringer@latest
	go install golang.org/x/tools/gopls@latest
	go install golang.org/x/vuln/cmd/govulncheck@latest
	@# Third-party.
	go install github.com/boyter/scc@latest
	go install github.com/bufbuild/buf/cmd/buf@latest
	go install github.com/charmbracelet/glow@latest
	go install github.com/kevwan/tproxy@latest
	go install github.com/maaslalani/slides@latest
	go install github.com/mbrt/gmailctl/cmd/gmailctl@latest
	go install github.com/orlangure/gocovsh@latest
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest

.PHONY: py-pkg
py-pkg:
	python3 -m pip install --user pip neovim
	pipx install --force black
	pipx install --force ipython
	pipx install --force git-fame
	pipx install --force pipenv
	pipx install --force ruff

.PHONY: rust-pkg
rust-pkg: .cargo/bin/cargo
	.cargo/bin/rustup update
	.cargo/bin/rustup component add rls-preview rust-analysis rust-analyzer rust-src
	.cargo/bin/cargo install --locked \
		git-branchless
	.cargo/bin/cargo install --locked nu

$(HOMEBREW):
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

.cargo/bin/cargo:
	curl https://sh.rustup.rs -sSf | sh

projects/roc/roc:
	rm -rf $(@D)
	rm -f Downloads/roc-nightly.tar.gz
	mkdir -p projects/roc
	curl -L -o Downloads/roc-nightly.tar.gz https://github.com/roc-lang/roc/releases/download/nightly/roc_nightly-macos_apple_silicon-latest.tar.gz
	tar xf Downloads/roc-nightly.tar.gz -C projects/roc --strip-components=1

.tmux/plugins/tpm/tpm:
	mkdir -p .tmux/plugins/tpm
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Add to double-colon rules above in a private, work-specific Makefile.
-include Dropbox/work.mk
