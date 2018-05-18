#!/bin/bash
set -eu

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $THIS_DIR/util/platform.sh

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
