#######################################
# vi everywhere
#######################################
export EDITOR="vim"
if (($+commands[nvim])); then
    alias vim="nvim"
    export EDITOR="nvim"
fi
alias e=$EDITOR

#######################################
# Plugins and Completion
#######################################
autoload -U compinit
compinit -i

[[ -f ~/projects/z/z.sh ]] && . ~/projects/z/z.sh
[[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
[[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -f ~/.zsh/theme.zsh ]] && source ~/.zsh/theme.zsh

#######################################
# Options
#######################################
unsetopt correct_all
setopt auto_cd
setopt no_beep
setopt prompt_subst

#######################################
# History
#######################################
if [ -z "$HISTFILE" ]; then
    HISTFILE=$HOME/.zsh_history
fi

HISTSIZE=10000
SAVEHIST=10000
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
# Aliases and shortcuts
#######################################
alias :q="exit"
alias :e=$EDITOR

if (($+commands[exa])); then
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
if (($+commands[xclip])); then
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
fi

# open Nautilus from terminals
if (($+commands[nautilus])); then
    open() {
        nautilus $1 &
    }
fi

#######################################
# node.js
#######################################
[[ -d "$HOME/.node-modules/bin" ]] && export PATH="$HOME/.node_modules/bin:$PATH"
export npm_config_prefix=~/.node_modules
nodeup() {
    [ -s "/usr/share/nvm/nvm.sh" ] && . /usr/share/nvm/nvm.sh
}

#######################################
# Languages and Terminfo
#######################################
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

#######################################
# Path additions
#######################################
[[ -d $HOME/bin ]] && export PATH=$HOME/bin:$PATH
[[ -d /usr/local/sbin ]] && export PATH=/usr/local/sbin:$PATH

#######################################
# Go
#######################################
export GOPATH=$HOME
[[ -d ~/.gimme/envs ]] && source ~/.gimme/envs/latest.env 2> /dev/null
if (($+commands[hardhat])); then
    alias hh="hardhat"
    eval "$(hardhat --completion-script-zsh)"
fi

#######################################
# Python
#######################################
export VIRTUAL_ENV_DISABLE_PROMPT=1
[[ -d $HOME/.local/bin ]] && export PATH=$HOME/.local/bin:$PATH

#######################################
# SSH
#######################################
eval $(keychain --eval --quiet ~/.ssh/id_rsa)

#######################################
# Job-related
#######################################
export GITHUB_USER=akshayjshah
source ~/.zsh/uber.zsh
