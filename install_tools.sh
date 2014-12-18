#!/bin/bash
set -eu

install_deb(){
    sudo apt-get install -y vim git-core tig tmux build-essential bash-completion sl curl ipython python-setuptools python-dev python-pip
}

install_mac(){
    brew install vim git tig tmux bash-completion sl curl coreutils
    sudo easy_install pip
}

error_msg="ERROR: not all dev tools were installed!"
install_deb || install_mac || echo $error_msg

