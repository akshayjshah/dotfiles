# See https://tech.davis-hansson.com/p/make/
SHELL := bash
.DELETE_ON_ERROR:
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

GO_VERSION := 1.17
PACMAN_NOWARN := grep -v 'warning: .* is up to date -- skipping$$'

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'


.PHONY: todo
todo:: ## List tasks not managed by this Makefile
	$(info Create an SSH key and upload it to GitHub.)
	$(info Change Windows Terminal starting dir: https://docs.microsoft.com/en-us/windows/terminal/troubleshooting#set-your-wsl-distribution-to-start-in-the-home--directory-when-launched.)
	$(info Initialize gmailctl.)
	$(info Enable native notifications in Chrome: chrome://flags)

.PHONY: setup
setup:: sys-pkg aur-pkg rust-pkg go-pkg py-pkg ## Set up a development environment
	$(MAKE) projects/z/z.sh  # z auto-jumper

.PHONY: sys-pkg
sys-pkg:
	sudo pacman -Syu --needed < pkg.txt 2>&1 | $(PACMAN_NOWARN)
	sudo pacman -S --asdeps < deps.txt 2>&1 | $(PACMAN_NOWARN) || true
	rustup default stable
	flatpak remote-add --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo

.PHONY: aur-pkg
aur-pkg: sys-pkg rust-pkg
	@# https://support.1password.com/install-linux/#arch-linux
	curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --import
	curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | gpg --import -
	curl -sS https://linux.dropbox.com/fedora/rpm-public-key.asc | gpg --import -
	@# Prevent Dropbox from auto-updating and putting systemd in a restart loop.
	rm -rf ~/.dropbox-dist && mkdir ~/.dropbox-dist && chmod 0400 ~/.dropbox-dist
	for pkg in `cat aurpkg.txt`; do \
		pacman -Qi "$$pkg" >/dev/null 2>&1 || rua install "$$pkg" ; \
		done
	sudo usermod -a -G informant $(USER)
	xdg-settings set default-web-browser google-chrome.desktop
	xdg-mime default google-chrome.desktop image/svg+xml
	flatpak install --user -y us.zoom.Zoom

.PHONY: update
update:: ## Update all managed packages and tools
	@# It's not worth sorting out which of these can run in parallel with
	@# system package updates.
	informant read
	sudo pacman -Syu
	$(MAKE) rust-pkg go-pkg py-pkg
	rua upgrade
	flatpak upgrade
	rm -rf projects/z .tmux/plugins
	$(MAKE) projects/z/z.sh
	nvim +PlugUpgrade +PlugUpdate +qa
	gmailctl apply

.PHONY: clean
clean:: ## Partially clean up installed resources
	sudo pacman -Sc
	paccache -r
	rm -f $(GOPATH)/bin/go1.*
	rm -rf projects/z
	rm -rf .tmux/plugins
	nvim +PlugClean +qa

projects/z/z.sh:
	rm -rf $(@D)
	git clone https://github.com/rupa/z ~/projects/z

.PHONY: go-pkg
go-pkg: sys-pkg
	GOPATH=$(HOME) go install golang.org/dl/go$(GO_VERSION)@latest
	[[ -d $(HOME)/sdk/go$(GO_VERSION) ]] || bin/go$(GO_VERSION) download
	GOPATH=$(HOME) bin/go$(GO_VERSION) get -u `paste -sd ' ' gopkg.txt`

.PHONY: py-pkg
py-pkg: sys-pkg
	python -m pip install -U `paste -sd ' ' pypkg.txt`

.PHONY: rust-pkg
rust-pkg: sys-pkg
	rustup update
	rustup component add rls-preview rust-analysis rust-src
	cargo install `paste -sd ' ' rustpkg.txt`

# Add to double-colon rules above in a private, work-specific Makefile.
-include /mnt/c/Users/aksha/Dropbox/work.mk
