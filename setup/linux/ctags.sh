#!/bin/bash
set -eu

# https://github.com/universal-ctags/ctags

# TODO: this is not for all Linux, only debian
sudo apt-get install -y autoconf

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
