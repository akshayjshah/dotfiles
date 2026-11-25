# See https://tech.davis-hansson.com/p/make/
SHELL := bash
.DELETE_ON_ERROR:
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-print-directory

export GOPATH := $(HOME)
export GOTOOLCHAIN := go1.27.4+auto

BREW := /opt/homebrew/bin/brew
RUSTUP := .cargo/bin/rustup

# Not managed:
# - Ghostty
# - Chrome
# - 1Password
# - Claude
# - Obsidian
# - Spotify
# - Raycast

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'

.PHONY: setup
setup: sys-pkg rust-pkg go-pkg ## Set up a development environment
	@# Homebrew casks are not working reliably
	$(info - [ ] Install Google Chrome)
	$(info - [ ] Install 1Password)
	$(info - [ ] Install Raycast)
	$(info - [ ] Install Ghostty)
	$(info - [ ] Install Docker Desktop)
	$(info - [ ] Install Zoom)
	$(info - [ ] Install Discord)
	$(info - [ ] Install Slack)
	$(info - [ ] Install Zulip)
	$(info - [ ] Install Spotify)
	$(info - [ ] Run `gh auth login` to set up the Github CLI)

.PHONY: update
update: ## Update all managed packages and tools
	@# It's not worth sorting out which of these can run in parallel with
	@# system package updates.
	$(BREW) update --quiet
	$(BREW) upgrade --quiet
	$(MAKE) go-pkg rust-pkg
	nvim +PlugUpgrade +PlugUpdate +qa
	gh extension upgrade --all

.PHONY: clean
clean: $(BREW) ## Partially clean up installed resources
	$(BREW) cleanup
	nvim +PlugClean +qa

.PHONY: sys-pkg
sys-pkg: $(BREW) $(RUSTUP)
	$(BREW) install --quiet $$(cat brew.txt)
	$(BREW) install --quiet $$(cat cask.txt)
	$(RUSTUP) -q default stable

.PHONY: go-pkg
go-pkg: sys-pkg
	go build -o bin/gofmt cmd/gofmt
	@# From Go project.
	go install golang.org/x/perf/cmd/benchstat@latest
	go install golang.org/x/review/git-codereview@latest
	go install \
		golang.org/x/tools/cmd/goimports@latest \
		golang.org/x/tools/cmd/stringer@latest
	go install golang.org/x/tools/gopls@latest
	go install golang.org/x/vuln/cmd/govulncheck@latest
	@# Third-party. Prefer Homebrew unless tools are tied to Go toolchain.
	go install github.com/orlangure/gocovsh@latest

.PHONY: rust-pkg
rust-pkg: $(RUSTUP) sys-pkg
	$(RUSTUP) -q update
	$(RUSTUP) -q component add rust-analysis rust-analyzer rust-src

$(BREW):
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

$(RUSTUP):
	curl https://sh.rustup.rs -sSf | sh
