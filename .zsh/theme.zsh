# Outputs current branch info in prompt format
function git_prompt_info() {
  local ref
  if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    echo " ${ref#refs/heads/}"
  fi
}

# Outputs the name of the current branch
# Usage example: git pull origin $(git_current_branch)
# Using '--quiet' with 'symbolic-ref' will not cause a fatal error (128) if
# it's not a symbolic ref, but in a Git repo.
function git_current_branch() {
  local ref
  ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}


# Get the status of the working tree
function git_prompt_status() {
  local INDEX STATUS
  INDEX=$(command git status --porcelain -b 2> /dev/null)
  STATUS=""
  if [ -n "$(git status --porcelain)" ]; then
    STATUS="$ZSH_THEME_GIT_PROMPT_DIRTY$STATUS"
  else
    STATUS="$ZSH_THEME_GIT_PROMPT_CLEAN$STATUS"
  fi

  echo $STATUS
}

# Get the current user and host, but hide expected values
function _user_host() {
  if [[ -n $SSH_CONNECTION ]]; then
    me="%n@%m"
  elif [[ $LOGNAME != $USER ]]; then
    me="%n"
  fi
  if [[ -n $me ]]; then
    echo "$me:"
  fi
}

local _return_status="%(?.•.✖)"

ZSH_THEME_GIT_PROMPT_DIRTY="⚑ "
ZSH_THEME_GIT_PROMPT_CLEAN="✓ "

PROMPT='${_return_status} $(_user_host)%c $(git_prompt_status)→ '
RPROMPT=' $(git_prompt_info)'