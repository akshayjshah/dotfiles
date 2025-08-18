# See https://tech.davis-hansson.com/p/make/
SHELL := bash
.DELETE_ON_ERROR:
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-print-directory

export GOPATH := $(HOME)
export GOTOOLCHAIN := go1.25.0+auto

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'

.PHONY: setup
setup: sys-pkg aur-pkg rust-pkg go-pkg ## Set up a development environment
	sudo usermod -a -G docker $(USER)
	@# Remember to:
	@#   - Disable mDNS in /etc/systemd/resolved.conf
	@#   - Add i915 to kernel modules in /etc/mkinitcpio.conf
	sudo systemctl enable avahi-daemon.service
	sudo systemctl enable bluetooth.service
	sudo systemctl enable cups.service
	sudo systemctl enable docker.socket
	sudo systemctl enable gdm.service
	sudo systemctl enable iptables.service
	sudo systemctl enable NetworkManager.service
	systemctl --user enable gcr-ssh-agent.socket

.PHONY: sys-pkg
sys-pkg:
	sudo pacman -Syu --needed - < arch.txt 2>&1
	rustup default stable

.PHONY: aur-pkg
aur-pkg: sys-pkg rust-pkg
	@# https://support.1password.com/install-linux/#arch
	curl -Ss https://downloads.1password.com/linux/keys/1password.asc | gpg --import
	.cargo/bin/rua install \
		1password \
		brother-hl2270dw \
		informant \
		google-chrome \
		slack-desktop \
		zulip-desktop
	sudo usermod -a -G informant $(USER)

.PHONY: update
update: ## Update all managed packages and tools
	@# It's not worth sorting out which of these can run in parallel with
	@# system package updates.
	informant read
	sudo pacman -Syu
	$(MAKE) rust-pkg go-pkg
	.cargo/bin/rua upgrade || true
	nvim +PlugUpgrade +PlugUpdate +qa
	gh extension upgrade --all

.PHONY: clean
clean: ## Partially clean up installed resources
	sudo pacman -Sc
	paccache -r
	nvim +PlugClean +qa

.PHONY: go-pkg
go-pkg: sys-pkg
	go build -o bin/gofmt cmd/gofmt
	@# From Go project.
	go install golang.org/x/perf/cmd/benchstat@latest
	go install golang.org/x/pkgsite/cmd/pkgsite@latest
	go install golang.org/x/review/git-codereview@latest
	go install \
		golang.org/x/tools/cmd/goimports@latest \
		golang.org/x/tools/cmd/stringer@latest
	go install golang.org/x/tools/gopls@latest
	go install golang.org/x/vuln/cmd/govulncheck@latest
	@# Third-party.
	go install github.com/boyter/scc@latest
	go install github.com/charmbracelet/glow@latest
	go install github.com/jesseduffield/lazydocker@latest
	go install github.com/maaslalani/slides@latest
	go install github.com/orlangure/gocovsh@latest
	go install github.com/spf13/cobra-cli@latest

.PHONY: rust-pkg
rust-pkg: sys-pkg
	rustup update
	rustup component add rust-analysis rust-analyzer rust-src
	cargo install rua
