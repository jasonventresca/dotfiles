#!/bin/bash
set -eu

REPO=$HOME/dotfiles.jason_ventresca

mkdir -p $REPO/bin # in case it's not there yet

source $REPO/util/platform.sh

install_deb() {
    sudo apt-get install -y \
        vim \
        git-core \
        tmux \
        build-essential \
        bash-completion \
        sl \
        curl \
        python-pip \
        npm \
        tree

    sudo pip install Pygments
    sudo npm install -g diff-so-fancy

    sudo $REPO/setup/debian/fpp.sh

    sudo $REPO/setup/linux/ctags.sh
}

install_mac() {
    # install Homebrew if not already (http://brew.sh)
    which brew >/dev/null || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    brew update
    brew install \
        vim \
        git \
        tmux \
        bash-completion \
        sl \
        curl \
        coreutils \
        jq \
        fpp \
        diff-so-fancy \
        tree

    brew install --with-default-names coreutils findutils gnu-tar gnu-sed gawk gnutls gnu-indent gnu-getopt
    brew tap homebrew/dupes; brew install grep

    # https://github.com/universal-ctags/homebrew-universal-ctags
    brew install --HEAD universal-ctags/universal-ctags/universal-ctags

    sudo easy_install pip
    sudo pip install Pygments
}

install_vim_plugin() {
    local project="$1"
    cd ${VIM_DIR}/bundle && git clone "git@github.com:${project}"
}

install_platform_agnostic() {
    local VIM_DIR=$REPO/dotfiles/vim

    [[ -e $REPO/bin/jsonp-multi ]] || \
            ln -s $REPO/scripts/linewise_json_pretty.py $REPO/bin/jsonp-multi

    # install pathogen for Vim
    # https://github.com/tpope/vim-pathogen
    if ! [[ -e $VIM_DIR/autoload/pathogen.vim ]]; then
        mkdir -p $VIM_DIR/{autoload,bundle} && \
            curl -LSso $VIM_DIR/autoload/pathogen.vim https://tpo.pe/pathogen.vim
    fi

    # install Vim plugin for aligning text (Tabular.vim)
    install_vim_plugin "godlygeek/tabular.git"

    # install fugitive Vim plugin
    install_vim_plugin "tpope/vim-fugitive.git"
    vim -u NONE -c "helptags vim-fugitive/doc" -c q

    # install flake8 and Vim plugin
    sudo pip install flake8
    install_vim_plugin "nvie/vim-flake8.git"

    # install Vim plugin for surrounding text with parens, brackets, quotes, xml tags and more
    install_vim_plugin "tpope/vim-surround.git"

    # install Emmet (lets you write HTML code faster)
    install_vim_plugin "mattn/emmet-vim.git"

    # For Terraform files, enable HCL/JSON syntax highlighting.
    # Also adds a :Terraform command that runs terraform, with tab completion of subcommands.
    install_vim_plugin "hashivim/vim-terraform.git"

    install_vim_plugin "ctrlpvim/ctrlp.vim.git"

#    # install python libraries that the rope vim plugin will import
#    # https://github.com/python-rope/rope
#    sudo pip install rope ropevim
#
#    # install Vim plugin for rope python tools
#    cd $VIM_DIR/bundle && git clone 'https://github.com/python-rope/ropevim.git'

}

ERROR_MSG="ERROR: not all dev tools were installed!"

if is_macOS ; then
    install_mac || echo $ERROR_MSG

elif is_Linux ; then
    install_deb || echo $ERROR_MSG

fi

install_platform_agnostic || echo $ERROR_MSG
