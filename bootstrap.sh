#!/bin/bash
set -eu

sudo apt-get install -y git-core || brew install git

git clone git@github.com:jasonventresca/dotfiles.git $HOME/dotfiles

$HOME/dotfiles/install.sh
