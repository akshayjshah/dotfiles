#!/usr/bin/env bash

function has() {
	hash "$1" 2>/dev/null
}

function addpath() {
    path=("$1" $path)
}

#######################################
# XDG Base Dirs
#######################################
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

#######################################
# Plugins and Completion
#######################################
autoload -U compinit
compinit -i

[[ -f ~/projects/z/z.sh ]] && . ~/projects/z/z.sh
[[ -f "$XDG_CONFIG_HOME"/fzf/fzf.zsh ]] && source "$XDG_CONFIG_HOME"/fzf/fzf.zsh
if has fd; then
    export FZF_DEFAULT_COMMAND='fd --hidden --type f --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi
if has jj; then
    source $(jj util completion --zsh)
fi

#######################################
# Options
#######################################
unsetopt correct_all
setopt auto_cd
setopt no_beep
setopt prompt_subst
# Unit tests for many projects need more-generous soft limits on FDs.
ulimit -S -n 4096

#######################################
# History
#######################################
if [ -z "$HISTFILE" ]; then
	export HISTFILE=$HOME/.zsh_history
fi

export SAVEHIST=1000000 # entries to save
export HISTSIZE=1000000 # entries to load

# Show history.
HIST_STAMPS="yyyy-mm-dd"
case $HIST_STAMPS in
"mm/dd/yyyy") alias history='fc -fl 1' ;;
"dd.mm.yyyy") alias history='fc -El 1' ;;
"yyyy-mm-dd") alias history='fc -il 1' ;;
*) alias history='fc -l 1' ;;
esac

setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_verify

# ...but we'd prefer to use McFly instead
if has mcfly; then
    eval "$(mcfly init zsh)"
fi

#######################################
# Languages and Terminfo
#######################################
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

#######################################
# Path additions
#######################################
# Keep entries unique
typeset -U path
# Homebrew-installed GNU coreutils
BREW_PREFIX=$HOME
if has brew; then
    BREW_PREFIX=$(brew --prefix)
fi
[[ -d /usr/local/sbin ]] && addpath '/usr/local/sbin'
[[ -d "$BREW_PREFIX"/opt/coreutils/libexec/gnubin ]] && addpath "$BREW_PREFIX/opt/make/libexec/gnubin"
[[ -d "$BREW_PREFIX"/share/google-cloud-sdk ]] && source "$BREW_PREFIX"/share/google-cloud-sdk/{completion,path}.zsh.inc
[[ -d /opt/homebrew ]] && addpath '/opt/homebrew/bin' \
    && addpath '/opt/homebrew/sbin' \
    && addpath '/opt/homebrew/opt/make/libexec/gnubin' \
    && addpath '/opt/homebrew/opt/curl/bin'
[[ -d $HOME/.cargo/bin ]] && addpath "$HOME/.cargo/bin"
[[ -d $HOME/.local/bin ]] && addpath "$HOME/.local/bin"
[[ -d $HOME/bin ]] && addpath "$HOME/bin"
export PATH

#######################################
# vi everywhere
#######################################
# NB, this must come *after* path additions above.
export EDITOR="vim"
if has nvim; then
	alias vim="nvim"
	alias vimdiff="nvim -d"
	export EDITOR="nvim"
fi

#######################################
# Go
#######################################
export GOPATH=$HOME

#######################################
# Node.js (reluctantly)
#######################################
export NVM_DIR=$HOME/.nvm
[[ -d "$NVM_DIR" ]] || mkdir "$NVM_DIR"
[[ -f "$BREW_PREFIX"/opt/nvm/nvm.sh ]] && source "$BREW_PREFIX"/opt/nvm/nvm.sh

#######################################
# Aliases and shortcuts
#######################################
alias :q="exit"
alias :e=\$EDITOR

if has exa; then
	alias ls="exa"
	alias ll="exa -al"
	alias la="exa -a"
else
	alias ls="ls -CF"
	alias ll="ls -ahlF"
	alias la="ls -A"
fi

alias ts="tmux new-session -s"
alias ta="tmux attach -t"
alias tls="tmux ls"

autoload -U zmv
alias mmv="noglob zmv -W"

# pbcopy-like alias for xclip on Linux
if has clip.exe; then
	alias pbcopy='clip.exe'
	alias pbpaste='powershell.exe -command Get-Clipboard 2> /dev/null | dos2unix | head -c -1'
elif has xclip; then
	alias pbcopy='xclip -selection clipboard'
	alias pbpaste='xclip -selection clipboard -o'
elif has wl-copy; then
    alias pbcopy='wl-copy --type text'
    alias pbpaste='wl-paste --type text'
fi

# open GUI file manager from terminals
if has explorer.exe; then
    open() {
        explorer.exe "$1"
    }
elif has nautilus; then
	open() {
		nautilus "$1" &
	}
fi

# broot
[[ -d ~/.config/broot/launcher/bash ]] && source ~/.config/broot/launcher/bash/br

#######################################
# Prompt
#######################################
# Get the status of the working tree
function git_prompt_status() {
	local STATUS
	STATUS="]"
	if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
		STATUS="$ZSH_THEME_GIT_PROMPT_DIRTY$STATUS"
	else
		STATUS="$ZSH_THEME_GIT_PROMPT_CLEAN$STATUS"
	fi

	echo "$STATUS"
}

# Outputs current branch info in prompt format
function git_prompt_info() {
	local ref
	ref=$(command git symbolic-ref HEAD 2>/dev/null) ||
		ref=$(command git rev-parse --short HEAD 2>/dev/null) || return 0
	echo "[${ref#refs/heads/} $(git_prompt_status)"
}

local _return_status="%(?. .!)"

ZSH_THEME_GIT_PROMPT_DIRTY="! "
ZSH_THEME_GIT_PROMPT_CLEAN="- "

export PROMPT='${_return_status} %c $(git_prompt_info) > '

#######################################
# SSH
#######################################
if has keychain; then
    eval "$(keychain --eval --quiet ~/.ssh/id_ed25519)"
fi

#######################################
# direnv (must be last!)
#######################################
if has direnv; then
    eval "$(direnv hook zsh)"
fi

