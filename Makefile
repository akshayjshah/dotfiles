.DEFAULT_GOAL := help

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'

.PHONY: all
all: go-pkg py-pkg projects projects/z ## Set up a new development machine

.PHONY: go-pkg
go-pkg: ## Install commonly-used Go language libraries
	go get -u \
		github.com/golang/lint/golint \
		golang.org/x/tools/cmd/... \
		github.com/google/godepq \
		github.com/alecthomas/gometalinter \
		honnef.co/go/tools/cmd/...

.PHONY: py-pkg
py-pkg: ## Install commonly-used Python language libraries
	pip2 install --user -U neovim yapf proselint virtualenv
	pip3 install --user -U neovim yapf proselint virtualenv

projects: ## Create directories for code projects and binaries
	mkdir -p ~/bin
	mkdir -p ~/projects
	mkdir -p ~/projects/uber

projects/z: projects ## Install the z auto-jumper
	git clone https://github.com/rupa/z ~/projects/z
