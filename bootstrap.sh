#!/bin/bash
set -eu
DOTFILES=$HOME/dotfiles.jason_ventresca

install_git() {
    if uname | grep -i darwin >/dev/null ; then
        # Mac OS X
        brew install git
    else
        # Ubuntu
        sudo apt-get install -y git-core
    fi
}

if [ -d $DOTFILES ] ; then
    echo "Dotfiles already installed. Checking for updates..."
    cd $DOTFILES && git pull origin master
else
    echo "Dotfiles not installed yet."
    # install git if not already
    if ! git --version 1>/dev/null 2>/dev/null ; then
        install_git
    fi

    echo "Downloading dotfiles now..."
    local REMOTE='git@github.com:jasonventresca/dotfiles.git'

    git clone $REMOTE $DOTFILES

    cd $DOTFILES && git remote set-url origin $REMOTE
fi

$DOTFILES/install.sh

echo "OK, done!"
