#!/bin/bash
set -eu

REMOTE='git@github.com:jasonventresca/dotfiles.git'

# Source bash files directly from github (via the "raw" feature).
function import_from_github() {
    local rel_path="$1"

    local url_base='https://raw.githubusercontent.com/jasonventresca/dotfiles/master'
    source <(curl "${url_base}/${rel_path}" 2>/dev/null)
}

import_from_github util/vars.sh
import_from_github util/platform.sh


install_git() {
    if is_macOS ; then
        brew install git

    elif is_Linux ; then
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
