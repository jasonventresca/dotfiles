#!/bin/bash
set -eu

REMOTE='git@github.com:jasonventresca/dotfiles.git'

############################################################
# TODO: The following exists in util/platform.sh.
#       Rather than duplicating it here, maybe we should do
#       something like:
#       source <(curl "github.com/path/to/raw/platform.sh")
PLATFORM_MACOS='Darwin'
PLATFORM_LINUX='Linux'

function is_macOS() {
    [[ $(uname) = ${PLATFORM_MACOS} ]]
}

function is_Linux() {
    [[ $(uname) = ${PLATFORM_LINUX} ]]
}
############################################################

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $THIS_DIR/util/platform.sh

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
