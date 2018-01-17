#!/usr/bin/env zsh

# env zsh
export HISTFILE=~/.zsh_history
export HISTSIZE=2000
export SAVEHIST=$HISTSIZE
export EDITOR="subl --wait" # sublime text

if [[ $(uname) = 'Darwin' ]] then
    if type brew > /dev/null; then
        export OPENSSL_INCLUDE_DIR=$(brew --prefix openssl)/include
        export OPENSSL_LIB_DIR=$(brew --prefix openssl)/lib
        export DEP_OPENSSL_INCLUDE=$(brew --prefix openssl)/include
    fi
fi

# aliases
if type exa > /dev/null; then
    alias ls='exa'
fi

if type rg > /dev/null; then
    alias grep='rg'
fi

alias ll='ls -la --git'
alias l='ll'
alias gs="git log --oneline --decorate -8 2> /dev/null && echo; git status"
alias gc="git commit"
alias gp="git push"
alias ga="git add"

# setup history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduceblanks

# git config
git config --global core.editor $EDITOR
git config --global alias.ls 'log --oneline --decorate --graph -8'
git config --global alias.la 'log --oneline --decorate --graph --all'
git config --global alias.ll 'log --oneline --decorate --graph --all -16'

# fn + delete
bindkey '\e[3~' delete-char
# binding key for history
bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward

# edit command in emacs
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^[e" edit-command-line

# move word
bindkey "\e\e[D" backward-word
bindkey "\e\e[C" forward-word

# Completion
# https://github.com/Homebrew/homebrew-completions
fpath=($HOME/completion $HOME/.brew/share/zsh/site-functions $HOME/.brew/share/zsh-completions $fpath)
autoload -U compinit
compinit

zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%Bno matches for: %d%b'
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# case insensitive completion
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'

# cache completion
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh_cache

# completion colors
zmodload zsh/complist
setopt extendedglob
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=36=31"

# command correction
setopt correctall

# setup prompt
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:git*' formats "%b %m%u%c "
zstyle ':vcs_info:*' check-for-changes true

# my prompt
setopt PROMPT_SUBST
function git_branch {
    local branch=$(git name-rev $(git rev-parse --short HEAD 2> /dev/null) 2> /dev/null)
    if [[ ! -z $branch ]] then
        echo $branch" "
    fi
}

function get_pwd {
    echo "%20<...<%c%<<"
}

function git_dirty_repo {
    if [[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]] then
        echo "%F{red};%f"
    else
        echo "%F{white};%f"
    fi
}

export PROMPT='%F{red}%(?..%? )'\
'%F{white}%B%(2L.+ .)%(1j.[%j] .)'\
'%F{green}$(git_branch)'\
'%F{yellow}$(get_pwd)%f'\
'$(git_dirty_repo) %b'

# swap buffer
function swap_buffer {
	local tmp_buffer=$SWAP_BUFFER
	SWAP_BUFFER=$BUFFER
	BUFFER=$tmp_buffer
}

# swap_buffer shortcut
zle -N swap_buffer
bindkey '^B' swap_buffer

# beep shortcut
bindkey '^N' beep

# live command color
source ~/zsh-syntax-highlighting.zsh
