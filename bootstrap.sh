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
    echo "Dotfiles repo already cloned. Pulling any updates..."
    cd $REPO && git pull origin master

else
    echo "Dotfiles repo does not exist locally."
    # install git if not already
    if ! git --version 1>/dev/null 2>/dev/null ; then
        install_git
    fi

    echo "Cloning dotfiles..."
    git clone $REMOTE $REPO

    cd $REPO && git remote set-url origin $REMOTE

    echo "Dotfiles cloned successfully."
fi

echo "Installing dev tools..."
$REPO/setup/dev_tools.sh

echo "Installing dotfiles..."
$REPO/setup/dotfiles.sh

echo "OK, done!"
