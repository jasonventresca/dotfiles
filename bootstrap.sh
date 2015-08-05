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
    echo "Dotfiles not yet installed. Downloading now..."
    # install git if not already
    if ! git --version 1>/dev/null 2>/dev/null ; then
        install_git
    fi

    git clone git@github.com:jasonventresca/dotfiles.git $DOTFILES

    $DOTFILES/install.sh
fi

echo "OK, done!"
