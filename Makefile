# See https://tech.davis-hansson.com/p/make/
SHELL := bash
.DELETE_ON_ERROR:
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-print-directory

GO_VERSION := 1.18

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
setup:: sys-pkg rust-pkg ## Set up a development environment
	$(MAKE) go-pkg py-pkg
	$(MAKE) projects/z/z.sh
	$(MAKE) .tmux/plugins/tpm/tpm

.PHONY: sys-pkg
sys-pkg:: $(HOMEBREW) .cargo/bin/cargo
	brew tap cantino/mcfly
	brew tap homebrew/cask
	brew tap homebrew/cask-fonts
	brew install $$(cat brewpkg.txt)
	$$(brew --prefix)/opt/fzf/install --no-fish --no-update-rc --xdg --key-bindings --completion
	brew install --cask $$(cat caskpkg.txt)
	.cargo/bin/rustup default stable

.PHONY: update
update:: $(HOMEBREW) ## Update all managed packages and tools
	@# It's not worth sorting out which of these can run in parallel with
	@# system package updates.
	brew update
	brew upgrade
	$(MAKE) rust-pkg go-pkg py-pkg
	rm -rf projects/z .tmux/plugins
	$(MAKE) projects/z/z.sh
	$(MAKE) .tmux/plugins/tpm/tpm
	gcloud components update
	nvim +PlugUpgrade +PlugUpdate +qa
	gmailctl apply

.PHONY: clean
clean:: ## Partially clean up installed resources
	brew cleanup
	rm -f $(GOPATH)/bin/go1.* $(GOPATH)/bin/go{,fmt}
	rm -rf projects/z
	rm -rf .tmux/plugins
	nvim +PlugClean +qa

.PHONY: go-pkg
go-pkg:
	rm -f bin/go{,$(GO_VERSION)}
	GOPATH=$(HOME) go install golang.org/dl/go$(GO_VERSION)@latest
	[[ -d $(HOME)/sdk/go$(GO_VERSION) ]] || bin/go$(GO_VERSION) download
	ln -s ~/bin/go$(GO_VERSION) ~/bin/go
	GOPATH=$(HOME) bin/go$(GO_VERSION) build -o bin/gofmt cmd/gofmt
	GOPATH=$(HOME) bin/go$(GO_VERSION) install github.com/boyter/scc@latest
	GOPATH=$(HOME) bin/go$(GO_VERSION) install github.com/mbrt/gmailctl/cmd/gmailctl@latest
	GOPATH=$(HOME) bin/go$(GO_VERSION) install golang.org/x/lint/golint@latest
	GOPATH=$(HOME) bin/go$(GO_VERSION) install golang.org/x/perf/cmd/benchstat@latest
	GOPATH=$(HOME) bin/go$(GO_VERSION) install \
		golang.org/x/tools/cmd/godoc@latest \
		golang.org/x/tools/cmd/goimports@latest \
		golang.org/x/tools/cmd/gorename@latest \
		golang.org/x/tools/cmd/stringer@latest
	GOPATH=$(HOME) bin/go$(GO_VERSION) install golang.org/x/tools/gopls@latest
	GOPATH=$(HOME) bin/go$(GO_VERSION) install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
	GOPATH=$(HOME) bin/go$(GO_VERSION) install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	GOPATH=$(HOME) bin/go$(GO_VERSION) install github.com/orlangure/gocovsh@latest
	GOPATH=$(HOME) bin/go$(GO_VERSION) install github.com/maaslalani/slides@latest

.PHONY: bin/gotip
bin/gotip:
	GOPATH=$(HOME) go install golang.org/dl/gotip@latest
	bin/gotip download

.PHONY: py-pkg
py-pkg:
	python3 -m pip install -U $$(cat pypkg.txt)

.PHONY: rust-pkg
rust-pkg: .cargo/bin/cargo
	.cargo/bin/rustup update
	.cargo/bin/rustup component add rls-preview rust-analysis rust-src
	.cargo/bin/cargo install --locked $$(cat rustpkg.txt)

$(HOMEBREW):
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
