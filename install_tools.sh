#!/bin/bash
set -eu

diff_highlight_raw_src_url='https://raw.githubusercontent.com/git/git/master/contrib/diff-highlight/diff-highlight'
diff_highlight_script=$REPO/bin/diff-highlight

mkdir -p $REPO/bin # in case it's not there yet

install_deb(){
    sudo apt-get install -y vim git-core tmux build-essential bash-completion sl curl python-pip
    sudo pip install Pygments
    wget --no-check-certificate $diff_highlight_raw_src_url -O - >$diff_highlight_script
    chmod u+x $diff_highlight_script

    sudo $REPO/install_fpp_ubuntu.sh
}

install_mac(){
    # install Homebrew if not already (http://brew.sh)
    which brew >/dev/null || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    brew update
    brew install vim git tmux bash-completion sl curl coreutils jq fpp
    brew install gnu-sed --with-default-names # sed on Mac OS X sucks
    sudo easy_install pip
    sudo pip install Pygments
    curl $diff_highlight_raw_src_url >$diff_highlight_script
    chmod u+x $diff_highlight_script
}

install_platform_agnostic(){
    local VIM_DIR=$REPO/dotfiles/vim

    # install pathogen for Vim
    # https://github.com/tpope/vim-pathogen
    mkdir -p $VIM_DIR/{autoload,bundle} && \
        curl -LSso $VIM_DIR/autoload/pathogen.vim https://tpo.pe/pathogen.vim

    # install Vim plugin for aligning text (Tabular.vim)
    cd $VIM_DIR/bundle && git clone git://github.com/godlygeek/tabular.git

    # install fugitive Vim plugin
    cd $VIM_DIR/bundle
    git clone git://github.com/tpope/vim-fugitive.git
    vim -u NONE -c "helptags vim-fugitive/doc" -c q

#    # install python libraries that the rope vim plugin will import
#    # https://github.com/python-rope/rope
#    sudo pip install rope ropevim
#
#    # install Vim plugin for rope python tools
#    cd $VIM_DIR/bundle && git clone 'https://github.com/python-rope/ropevim.git'
}

ERROR_MSG="ERROR: not all dev tools were installed!"

if uname | grep -i darwin >/dev/null ; then
    install_mac || echo $ERROR_MSG
else
    install_deb || echo $ERROR_MSG
fi

install_platform_agnostic || echo $ERROR_MSG
