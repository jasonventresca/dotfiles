#!/bin/bash
set -eu

install_deb(){
    sudo apt-get install -y vim git-core tmux build-essential bash-completion sl curl
}

install_mac(){
    brew install vim git tmux bash-completion sl curl coreutils
    sudo easy_install pip
}

error_msg="ERROR: not all dev tools were installed!"
install_deb || install_mac || echo $error_msg

