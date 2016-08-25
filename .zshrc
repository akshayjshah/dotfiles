#######################################
# vi everywhere
#######################################
export EDITOR="emacsclient -t"
alias e="emacsclient -t"
# Force emacsclient -t to start a server if necessary.
export ALTERNATE_EDITOR=""
if (($+commands[nvim])); then
    alias vim="nvim"
fi

#######################################
# Languages and Terminfo
#######################################
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

#######################################
# Plugins and Completion
#######################################
autoload -U compinit
compinit -i

eval "$(fasd --init auto)"
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
alias ls="ls -CF"
alias ll="ls -ahlF"
alias la="ls -A"

alias ts="tmux new-session"
alias ta="tmux attach"
alias tls="tmux ls"

autoload -U zmv
alias mmv="noglob zmv -W"

#######################################
# Path additions
#######################################
[[ -d $HOME/bin ]] && export PATH=$HOME/bin:$PATH

#######################################
# Go
#######################################
export GOPATH=$HOME

#######################################
# Python
#######################################
export VIRTUAL_ENV_DISABLE_PROMPT=1
export PROJECT_HOME=$HOME/projects

#######################################
# node.js
#######################################
[ -s "$HOME/.nvm/nvm.sh" ] && . $HOME/.nvm/nvm.sh

#######################################
# Job-related
#######################################
export GITHUB_USER=akshayjshah
source ~/.zsh/uber.zsh
