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
        python3-pip \
        ruby-dev \
        npm \
        tree

    # Install node.js
    curl -fsSL https://deb.nodesource.com/setup_23.x -o nodesource_setup.sh
    sudo -E bash nodesource_setup.sh
    sudo apt-get install -y nodejs
    node -v

    sudo $REPO/setup/debian/fpp.sh
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
        tree \
        node

    # This setup assumes we're using GNU bash v5+ from Homebrew
    # Check if bash is from Homebrew
    if [[ "$(which bash)" != "/opt/homebrew/bin/bash" ]]; then
        echo
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        echo "ERROR: GNU bash from Homebrew is not installed or not in PATH"
        echo "Please follow the following instructions, then re-run this script:"
        echo " -> https://stackoverflow.com/a/77052639 <- "
        echo
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        echo
        return 1
    fi
}

install_vim_plugin() {
    local project="$1"
    local repo_name=$(echo "$project" | cut -d'/' -f2-)
    if ! [[ -d "$VIM_DIR/bundle/$repo_name" ]] ; then
        git -C ${VIM_DIR}/bundle clone "git@github.com:${project}.git"
    fi
}

install_platform_agnostic() {
    local VIM_DIR=$REPO/dotfiles/vim

    [[ -e $REPO/bin/jsonp-multi ]] || \
            ln -s $REPO/scripts/linewise_json_pretty.py $REPO/bin/jsonp-multi

    # diff-so-fancy, for nicer looking git diffs.
    $REPO/setup/all/diff-so-fancy.sh

    # install pathogen for Vim
    # https://github.com/tpope/vim-pathogen
    if ! [[ -e $VIM_DIR/autoload/pathogen.vim ]]; then
        mkdir -p $VIM_DIR/{autoload,bundle} && \
            curl -LSso $VIM_DIR/autoload/pathogen.vim https://tpo.pe/pathogen.vim
    fi

    # install Vim plugin for aligning text (Tabular.vim)
    install_vim_plugin "godlygeek/tabular"

    # install fugitive Vim plugin
    install_vim_plugin "tpope/vim-fugitive"
    vim -u NONE -c "helptags vim-fugitive/doc" -c q

    # install Vim plugin for surrounding text with parens, brackets, quotes, xml tags and more
    install_vim_plugin "tpope/vim-surround"

    # install Emmet (lets you write HTML code faster)
    install_vim_plugin "mattn/emmet-vim"

    # For Terraform files, enable HCL/JSON syntax highlighting.
    # Also adds a :Terraform command that runs terraform, with tab completion of subcommands.
    install_vim_plugin "hashivim/vim-terraform"

    install_vim_plugin "ctrlpvim/ctrlp.vim"

    install_vim_plugin "jeetsukumaran/vim-buffergator"

}

function error_msg() {
    echo
    echo "ERROR: not all dev tools were installed!"
    echo
}

if is_macOS ; then
    install_mac || error_msg

elif is_Linux ; then
    install_deb || error_msg

fi

install_platform_agnostic || error_msg
