#!/usr/bin/env bash

function has() {
  hash "$1" 2>/dev/null
}

#######################################
# vi everywhere
#######################################
export EDITOR="vim"
if has nvim; then
  alias vim="nvim"
  alias vimdiff="nvim -d"
  export EDITOR="nvim"
fi

#######################################
# Plugins and Completion
#######################################
[[ -f /usr/local/etc/profile.d/autojump.sh ]] && . /usr/local/etc/profile.d/autojump.sh
[[ -f ~/.bazel-complete.bash ]] && source ~/.bazel-complete.bash

[[ -d ~/.fzf/bin ]] && export PATH=$HOME/.fzf/bin:$PATH
[[ -f ~/.fzf/shell/completion.bash ]] && source ~/.fzf/shell/completion.bash
[[ -f ~/.fzf/shell/key-bindings.bash ]] && source ~/.fzf/shell/key-bindings.bash
export FZF_DEFAULT_COMMAND='fd --hidden --type f --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

#######################################
# Options
#######################################
shopt -s autocd

#######################################
# History
#######################################
if [ -z "$HISTFILE" ]; then
  HISTFILE=$HOME/.bash_history
fi

export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=10000
export HISTFILESIZE=10000
shopt -s histappend
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

#######################################
# Prompt
#######################################
export PROMPT_COMMAND="_prompt_command; $PROMPT_COMMAND"

# Get the status of the working tree
function _git_prompt_status() {
  if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
    echo " !"
  fi
}

# Output current branch info in prompt format
function _git_prompt_info() {
  local ref
  ref=$(command git symbolic-ref HEAD 2>/dev/null) ||
    ref=$(command git rev-parse --short HEAD 2>/dev/null) || return 0
  echo "[${ref#refs/heads/}$(_git_prompt_status)]"
}

function _prompt_command() {
  local _return_status="$?"
  PS1=""
  if [ $_return_status != 0 ]; then
    PS1+="! "
  else
    PS1+="  "
  fi
  PS1+="\w $(_git_prompt_info)"
  PS1+=" > "
}

#######################################
# Languages and Terminfo
#######################################
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

#######################################
# Path additions
#######################################
[[ -d /usr/local/sbin ]] && export PATH=/usr/local/sbin:$PATH
[[ -d $HOME/bin ]] && export PATH=$HOME/bin:$PATH

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

alias ts="tmux new-session -s"
alias ta="tmux attach -t"
alias tls="tmux ls"

#######################################
# direnv (must be last!)
#######################################
eval "$(direnv hook bash)"
