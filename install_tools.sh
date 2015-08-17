#!/bin/bash
set -eu

install_deb(){
    sudo apt-get install -y vim git-core tmux build-essential bash-completion sl curl
}

install_mac(){
    brew install vim git tmux bash-completion sl curl coreutils
    sudo easy_install pip
}

ERROR_MSG="ERROR: not all dev tools were installed!"

if uname | grep -i darwin >/dev/null ; then
    install_mac || echo $ERROR_MSG
else
    install_deb || echo $ERROR_MSG
fi
