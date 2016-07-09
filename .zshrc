#######################################
# vi everywhere
#######################################
export EDITOR="emacsclient -t"
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
# This is a lie, but makes zsh work in emacs.
export TERM=xterm-256color

#######################################
# Plugins and Completion
#######################################
autoload -U compinit
compinit -i

zplugs=()
ZPLUG_HOME=$HOME/.zsh/zplug
{ [[ -d $ZPLUG_HOME ]] || git clone https://github.com/zplug/zplug $ZPLUG_HOME }
source $ZPLUG_HOME/init.zsh
zplug "zplug/zplug"

zplug "plugins/gitignore", from:oh-my-zsh, if:"(( $+commands[git] ))"
zplug "plugins/golang", from:oh-my-zsh, if:"(( $+commands[go] ))"
zplug "plugins/tmux", from:oh-my-zsh, if:"(( $+commands[tmux] ))"
zplug "plugins/vi-mode", from:oh-my-zsh
zplug "plugins/z", from:oh-my-zsh

# Install plugins if necessary.
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

[[ -f ~/.zsh/theme.zsh ]] && source ~/.zsh/theme.zsh
[[ -f /usr/local/opt/fzf/shell/key-bindings.zsh ]] && source /usr/local/opt/fzf/shell/key-bindings.zsh
[[ -f /usr/local/opt/fzf/shell/completion.zsh ]] && source /usr/local/opt/fzf/shell/completion.zsh

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
alias e="emacsclient -t"
alias ls="ls -CF"
alias ll="ls -ahlF"
alias la="ls -A"

autoload -U zmv
alias mmv="noglob zmv -W"

#######################################
# Path additions
#######################################
if command -v brew >/dev/null 2>&1
then
    export PATH=$(brew --prefix)/sbin:$(brew --prefix)/bin:$PATH
    if [[ -d $(brew --prefix)/lib/node_modules ]]
    then
        export NODE_PATH=$(brew --prefix)/lib/node_modules:$NODE_PATH
    fi
fi

[[ -d $HOME/bin ]] && export PATH=$HOME/bin:$PATH
[[ -d ~/projects ]] && hash -d p=~/projects

#######################################
# Go
#######################################
export GOPATH=$HOME

if [[ -d /usr/local/opt/go/libexec ]]
then
    export GOROOT=/usr/local/opt/go/libexec
    export PATH=$PATH:/usr/local/opt/go/libexec/bin
fi

#######################################
# Python
#######################################
export VIRTUAL_ENV_DISABLE_PROMPT=1
export PROJECT_HOME=$HOME/projects
[ -s "/usr/local/bin/virtualenvwrapper.sh" ] && . /usr/local/bin/virtualenvwrapper.sh

#######################################
# node.js
#######################################
[ -s "$HOME/.nvm/nvm.sh" ] && . $HOME/.nvm/nvm.sh

#######################################
# Job-related
#######################################
export GITHUB_USER=akshayjshah
source ~/.zsh/uber.zsh
