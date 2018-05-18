#!/bin/bash
set -eu

REPO=$HOME/dotfiles.jason_ventresca

source $REPO/util/platform.sh

function install_linux() {
    (
        cd $HOME
        git clone 'https://github.com/universal-ctags/ctags.git'
        cd ctags
        ./autogen.sh
        ./configure
        make
        sudo make install
        cd $HOME
        rm -rf ctags
    )
}

if is_macOS ; then
    true # TODO

elif is_Linux ; then
    install_linux
fi
