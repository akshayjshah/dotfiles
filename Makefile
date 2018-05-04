.DEFAULT_GOAL := help

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'

.PHONY: go-pkg
go-pkg: ## Install commonly-used Go language libraries
	go get -u \
		github.com/golang/lint/golint \
		github.com/golang/dep/cmd/dep \
		golang.org/x/tools/cmd/... \
		golang.org/x/vgo \
		github.com/google/godepq \
		github.com/alecthomas/gometalinter \
		honnef.co/go/tools/cmd/... \
		mvdan.cc/gogrep \
		github.com/akshayjshah/hardhat

.PHONY: py-pkg
py-pkg: ## Install commonly-used Python language libraries
	pip2 install --user -U neovim yapf virtualenv
	pip3 install --user -U neovim yapf virtualenv

.PHONY: cargo
cargo: .cargo/bin/cargo

.cargo/bin/cargo:
	curl https://sh.rustup.rs -sSf | sh

.PHONY: rust-pkg
rust-pkg: cargo ## Install commonly-used Rust language libraries
	rustup update
	cargo install --force \
		ripgrep \
		exa \
		fd-find

.PHONY: fedora
fedora: ## Install Fedora system packages
	sudo dnf install \
		aspell \
		cmake \
		curl \
		dnf-plugins-core \
		gcc \
		gcc-c++ \
		git \
		git-fame \
		gnome-tweak-tool \
		htop \
		jq \
		keychain \
		make \
		mozilla-fira-mono-fonts \
		mozilla-fira-sans-fonts \
		neovim \
		powerline-fonts \
		python2 \
		python2-neovim \
		python3 \
		python3-neovim \
		ranger \
		redis \
		ruby \
		sqlite \
		tig \
		tmux \
		vim-enhanced \
		wget \
		xclip \
		zlib-devel \
		zsh
	sudo dnf copr enable --assumeyes vbatts/bazel
	sudo dnf install --assumeyes bazel

.PHONY: flatpak
flatpak: ## Install FlatPaks
	sudo flatpak remote-add --if-not-exists --from gnome https://sdk.gnome.org/gnome.flatpakrepo
	sudo flatpak remote-add --if-not-exists --from org.mozilla.FirefoxRepo https://firefox-flatpak.mojefedora.cz/org.mozilla.FirefoxRepo.flatpakrepo
	sudo flatpak remote-add --if-not-exists --from flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	sudo flatpak install org.mozilla.FirefoxRepo org.mozilla.FirefoxDevEdition
	sudo flatpak install flathub com.slack.Slack
	sudo flatpak install flathub us.zoom.Zoom

.PHONY: docker
docker: ## Install Docker
	sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
	sudo dnf install docker-ce
	sudo usermod -aG docker $(USER)
	sudo systemctl enable docker
	sudo systemctl start docker

.PHONY: update
update: ## Update Fedora system packages & FlatPaks
	sudo dnf upgrade --assumeyes
	sudo flatpak update
	nvim +PlugUpgrade +PlugUpdate +qa

.PHONY: dirs
dirs: projects bin projects/uber ## Create directories for code projects and binaries

bin:
	mkdir -p ~/bin

.PHONY: gimme
gimme: bin/gimme ## Install gimme, a Go version manager

bin/gimme: bin
	wget -O bin/gimme https://raw.githubusercontent.com/travis-ci/gimme/master/gimme
	chmod +x bin/gimme

projects:
	mkdir -p ~/projects

projects/uber:
	mkdir -p ~/projects/uber

.PHONY: z
z: projects ## Install the z auto-jumper
	mkdir -p ~/projects/z
	git clone https://github.com/rupa/z ~/projects/z

.PHONY: diff-so-fancy
diff-so-fancy: bin/diff-so-fancy ## Install diff-so-fancy, a git diff prettifier

bin/diff-so-fancy: bin
	wget -O bin/diff-so-fancy https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy
	chmod +x bin/diff-so-fancy

.PHONY: nvm
nvm: .nvm/nvm.sh ## Install the node.js version manager

.nvm/nvm.sh:
	wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash

.PHONY: nova
nova: bin/nova-gnome-terminal.sh ## Install a script to add Nova colors to a GNOME Terminal profile
bin/nova-gnome-terminal.sh:
	wget -O bin/nova-gnome-terminal.sh https://raw.githubusercontent.com/agarrharr/nova-gnome-terminal/master/build/install.sh
	chmod +x bin/nova-gnome-terminal.sh

.PHONY: fira-powerline
fira-powerline: .fonts/fura-mono-regular-powerline.otf ## Install a Powerline-patched Fira Mono font

.fonts/fura-mono-regular-powerline.otf:
	mkdir -p .fonts
	wget -O .fonts/fura-mono-regular-powerline.otf https://github.com/powerline/fonts/raw/master/FiraMono/FuraMono-Regular%20Powerline.otf
	fc-cache -v

.PHONY: buck
buck: ## Install Facebook's Buck build tool
	# Need Oracle JDK: download from website, install with `sudo rpm -ivh
	# jdk.rpm`, and then `sudo alternatives --config java`
	sudo dnf install ant python2 git
	mkdir -p projects/buck
	git clone https://github.com/facebook/buck.git projects/buck || true
	cd projects/buck && git checkout master && git pull
	cd projects/buck && ant

WATCHMAN_VERSION := v4.9.0
.PHONY: watchman
watchman:
	sudo dnf install \
		openssl-devel \
		autoconf \
		automake \
		libtool \
		pcre \
		python-devel
	git clone https://github.com/facebook/watchman.git projects/watchman || true
	cd projects/watchman && git checkout master && git pull && git checkout $(WATCHMAN_VERSION)
	cd projects/watchman && ./autogen.sh
	cd projects/watchman && ./configure
	$(MAKE) -C projects/watchman -j $(shell nproc)
	sudo $(MAKE) -C projects/watchman install
	# https://facebook.github.io/watchman/docs/install.html#system-specific-preparation
	echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
