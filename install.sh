#!/bin/sh

# This script must be ran from inside the dotfiles repository
# and will mostly just setup the config files by pulling the
# submodules and doing symbolic links.

set -ve

git submodule update --init --recursive

ln -s .zshrc $HOME
ln -s zsh-syntax-highlighting/zsh-syntax-highlighting.zsh $HOME
ln -s .nix-profile $HOME/profile
