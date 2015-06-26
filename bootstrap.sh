#!/bin/sh
set -eu

# Use this script to (re)build a familiar command line env

# Don't forget the SSH keys.
# Need to sudo to sucessfully apt-get

# first install git
sudo apt-get install -y git-core || brew install git

# Install these dotfiles locally
mkdir -p $HOME/dotfiles
echo "Cloning dotfiles repo from github"
git clone git@github.com:jasonventresca/dotfiles.git $HOME/dotfiles
git clone git://github.com/sophacles/vim-bundle-mako.git $HOME/dotfiles/vim-bundle-mako

$HOME/dotfiles/install.sh
