#!/bin/bash
set -eu

diff_highlight_raw_src_url='https://raw.githubusercontent.com/git/git/master/contrib/diff-highlight/diff-highlight'
diff_highlight_script=$REPO/bin/diff-highlight

install_deb(){
    sudo apt-get install -y vim git-core tmux build-essential bash-completion sl curl python-pip
    sudo pip install Pygments
    wget --no-check-certificate $diff_highlight_raw_src_url -O $diff_highlight_script
    chmod u+x $diff_highlight_script
}

install_mac(){
    brew install vim git tmux bash-completion sl curl coreutils
    sudo easy_install pip
    sudo pip install Pygments
    curl $diff_highlight_raw_src_url >$diff_highlight_script
    chmod u+x $diff_highlight_script
}

ERROR_MSG="ERROR: not all dev tools were installed!"

if uname | grep -i darwin >/dev/null ; then
    install_mac || echo $ERROR_MSG
else
    install_deb || echo $ERROR_MSG
fi
