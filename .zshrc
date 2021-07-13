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
export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_CONFIG_DIRS="/etc/xdg"

#######################################
# Plugins and Completion
#######################################
autoload -U compinit
compinit -i

[[ -f ~/projects/z/z.sh ]] && . ~/projects/z/z.sh
[[ -d /usr/share/fzf ]] && source /usr/share/fzf/{key-bindings,completion}.zsh
export FZF_DEFAULT_COMMAND='fd --hidden --type f --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

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
	HISTFILE=$HOME/.zsh_history
fi

HISTSIZE=100000
HISTFILESIZE=100000
HIST_STAMPS="yyyy-mm-dd"

# Show history.
case $HIST_STAMPS in
"mm/dd/yyyy") alias history='fc -fl 1' ;;
"dd.mm.yyyy") alias history='fc -El 1' ;;
"yyyy-mm-dd") alias history='fc -il 1' ;;
*) alias history='fc -l 1' ;;
esac

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history

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
[[ -d /usr/local/opt/make/libexec/gnubin ]] && addpath '/usr/local/opt/make/libexec/gnubin'
[[ -d /usr/local/sbin ]] && addpath '/usr/local/sbin'
[[ -d $HOME/.cargo/bin ]] && addpath "$HOME/.cargo/bin"
[[ -d $HOME/bin ]] && addpath "$HOME/bin"
[[ -d $HOME/.local/bin ]] && addpath "$HOME/.local/bin"
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
_GOVERSION=$(grep GO_VERSION ~/Makefile | head -1 | cut -d' ' -f 3)
_GOBIN="$GOPATH"/bin/go"$_GOVERSION"
[[ -f "$_GOBIN" ]] && alias go="$_GOBIN"

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

if has fdfind; then
    # Homebrew installs fd as fdfind.
	alias fd="fdfind"
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
# Auto-start graphical session
#######################################
if ! grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null; then
    if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec sway
    fi
fi

#######################################
# SSH
#######################################
if has keychain; then
    eval "$(keychain --eval --quiet ~/.ssh/id_ed25519)"
fi

#######################################
# direnv (must be last!)
#######################################
eval "$(direnv hook zsh)"

