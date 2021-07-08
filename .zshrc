#!/usr/bin/env bash

function has() {
	hash "$1" 2>/dev/null
}

#######################################
# Plugins and Completion
#######################################
autoload -U compinit
compinit -i

[[ -f ~/projects/z/z.sh ]] && . ~/projects/z/z.sh
[[ -d ~/.fzf/bin ]] && export PATH=$HOME/.fzf/bin:$PATH
[[ -f ~/.fzf/shell/completion.zsh ]] && source ~/.fzf/shell/completion.zsh
[[ -f ~/.fzf/shell/key-bindings.zsh ]] && source ~/.fzf/shell/key-bindings.zsh
export FZF_DEFAULT_COMMAND='fdfind --hidden --type f --follow --exclude .git'
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
[[ -d /usr/local/opt/make/libexec/gnubin ]] && export PATH=/usr/local/opt/make/libexec/gnubin:$PATH
[[ -d /usr/local/sbin ]] && export PATH=/usr/local/sbin:$PATH
[[ -d $HOME/bin ]] && export PATH=$HOME/bin:$PATH
[[ -d $HOME/.local/bin ]] && export PATH=$HOME/.local/bin:$PATH

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
VERSION=$(grep GO_VERSION ~/Makefile | head -1 | cut -d' ' -f 3)
GO_ENV=~/.gimme/envs/go"$VERSION".env
[[ -f $GO_ENV ]] && source "$GO_ENV" 2>/dev/null

#######################################
# Rust
#######################################
[[ -f $HOME/.cargo/env ]] && source "$HOME/.cargo/env"

#######################################
# node.js
#######################################
export N_PREFIX="$HOME/n"
[[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"

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

# Set the GCP account to use.
if has gcloud; then
    function gwork() {
        gcloud config set account $1
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

	echo $STATUS
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

PROMPT='${_return_status} %c $(git_prompt_info) > '

#######################################
# Auto-start graphical session
#######################################
if ! grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null; then
    if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec sway
    fi
fi

#######################################
# SSH
#######################################
if has keychain; then
    eval $(keychain --eval --quiet ~/.ssh/id_ed25519)
fi

#######################################
# direnv (must be last!)
#######################################
eval "$(direnv hook zsh)"

