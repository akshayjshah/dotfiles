# Get the status of the working tree
function git_prompt_status() {
    local INDEX STATUS
    INDEX=$(command git status --porcelain -b 2> /dev/null)
    STATUS="]"
    if [ -n "$(git status --porcelain 2> /dev/null)" ]; then
        STATUS="$ZSH_THEME_GIT_PROMPT_DIRTY$STATUS"
    else
        STATUS="$ZSH_THEME_GIT_PROMPT_CLEAN$STATUS"
    fi

    echo $STATUS
}

# Outputs current branch info in prompt format
function git_prompt_info() {
    local ref
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
        ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    echo "[${ref#refs/heads/} $(git_prompt_status)"
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

PROMPT='${_return_status} $(_user_host)%c $(git_prompt_info)→ '
