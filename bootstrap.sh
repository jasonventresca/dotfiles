#!/bin/bash
set -eu
export REPO=$HOME/dotfiles.jason_ventresca
REMOTE='git@github.com:jasonventresca/dotfiles.git'

install_git() {
    if uname | grep -i darwin >/dev/null ; then
        # Mac OS X
        brew install git
    else
        # Ubuntu
        sudo apt-get install -y git-core
    fi
}

if [ -d $REPO ] ; then
    echo "Dotfiles already installed. Checking for updates..."
    cd $REPO && git pull origin master
else
    echo "Dotfiles not installed yet."
    # install git if not already
    if ! git --version 1>/dev/null 2>/dev/null ; then
        install_git
    fi

    echo "Downloading dotfiles now..."

    git clone $REMOTE $REPO

    cd $REPO && git remote set-url origin $REMOTE
fi

$REPO/install.sh

echo "OK, done!"
