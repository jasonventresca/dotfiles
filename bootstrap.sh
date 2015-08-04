#!/bin/bash
set -eu

git --version 1>/dev/null 2>/dev/null || \
    sudo apt-get install -y git-core || \ # git is not installed, try Ubuntu
    brew install git # try Mac OS X

git clone git@github.com:jasonventresca/dotfiles.git $HOME/dotfiles.jason_ventresca

$HOME/dotfiles.jasonventresca/install.sh
