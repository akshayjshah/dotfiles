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
[[ -d ~/.gimme/envs ]] && source ~/.gimme/envs/latest.env

#######################################
# Python
#######################################
export VIRTUAL_ENV_DISABLE_PROMPT=1
export PROJECT_HOME=$HOME/projects

#######################################
# Job-related
#######################################
export GITHUB_USER=akshayjshah
source ~/.zsh/uber.zsh
