#!/usr/bin/env zsh

# env zsh
export HISTFILE=~/.zsh_history
export HISTSIZE=2000
export SAVEHIST=$HISTSIZE

# env path
export PATH="$HOME/.brew/bin:$PATH" # home brew
export PATH="$HOME/.cargo/bin:$PATH" # cargo binaries
export PATH="$HOME/.cabal/bin:$PATH" # cabal binaries
export PATH="$HOME/.nix-profile/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.bin:$PATH"

# env misc
export GREP_COLOR=31
export EDITOR="code --wait" # visual studio code

if [[ $(uname) = 'Darwin' ]] then
    export OPENSSL_INCLUDE_DIR=$(brew --prefix openssl)/include
    export OPENSSL_LIB_DIR=$(brew --prefix openssl)/lib
    export DEP_OPENSSL_INCLUDE=$(brew --prefix openssl)/include
fi

# Rust racer
export RUST_SRC_PATH="$HOME/Documents/rust"

# aliases
alias ls='ls -G'
alias l='ll'
alias grep='rg'
alias gs="git log --oneline --decorate -8 2> /dev/null && echo; git status"
# alias git="git vcs_info"
alias gc="git commit"
alias gp="git push"
alias ga="git add"

# setup history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduceblanks

# git config
git config --global core.editor "code --wait"
git config --global alias.ls 'log --oneline --decorate --graph --all'

# useful function
function swap_buffer {
    local tmp_buffer=$SWAP_BUFFER
    SWAP_BUFFER=$BUFFER
    BUFFER=$tmp_buffer
}

zle -N swap_buffer
bindkey '^B' swap_buffer

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
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# case insensitive completion
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'

# Crée un cache des complétion possibles
# très utile pour les complétion qui demandent beaucoup de temps
# comme la recherche d'un paquet aptitude install moz<tab>
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh_cache

# des couleurs pour la complétion
# faites un kill -9 <tab><tab> pour voir :)
zmodload zsh/complist
setopt extendedglob
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=36=31"

# Correction des commandes
setopt correctall

# live command color
source ~/zsh-syntax-highlighting.zsh

# added by travis gem
[ -f /Users/crenault/.travis/travis.sh ] && source /Users/crenault/.travis/travis.sh

# setup prompt
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:git*' formats "%b %m%u%c "
zstyle ':vcs_info:*' check-for-changes true

function get_pwd {
    echo "%20<...<%c%<<"
}

export PROMPT='%F{red}%(?..%? )'\
'%F{white}%B%(2L.+ .)%(1j.[%j] .)'\
'%F{green}${vcs_info_msg_0_}'\
'%F{yellow}$(get_pwd)%f %b'
