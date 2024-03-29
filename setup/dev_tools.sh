#!/bin/bash
set -eux

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
        ruby-dev \
        npm \
        tree

    # https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions
    curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
    sudo apt-get install -y nodejs

    sudo pip install Pygments

    sudo $REPO/setup/debian/fpp.sh

    # TODO: Enable this when universal-ctags becomes a stable Debian/Ubuntu package
    #       (It's currently "unstable" at https://packages.debian.org/sid/editors/universal-ctags)
    #       The line below was disabled because it takes ~40s to build from source, and I don't
    #       want to wait that long most of the time I'm ssh'ing to a new box.
    # sudo $REPO/setup/linux/ctags.sh
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

    brew install --with-default-names coreutils findutils gnu-tar gnu-sed gawk gnutls gnu-indent gnu-getopt
    brew tap homebrew/dupes; brew install grep

    # https://github.com/universal-ctags/homebrew-universal-ctags
    brew install --HEAD universal-ctags/universal-ctags/universal-ctags

    sudo easy_install pip
    sudo pip install Pygments

    # This is platform-agnostic; however I typically only use this tool on my Mac.
    sudo npm install -g markserv
}

install_vim_plugin() {
    local project="$1"
    if ! [[ -d "$VIM_DIR/bundle/$project" ]] ; then
        cd ${VIM_DIR}/bundle && git clone "git@github.com:${project}.git"
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

    # install flake8 and Vim plugin
    sudo pip install flake8
    install_vim_plugin "nvie/vim-flake8"

    # install Vim plugin for surrounding text with parens, brackets, quotes, xml tags and more
    install_vim_plugin "tpope/vim-surround"

    # install Emmet (lets you write HTML code faster)
    install_vim_plugin "mattn/emmet-vim"

    # For Terraform files, enable HCL/JSON syntax highlighting.
    # Also adds a :Terraform command that runs terraform, with tab completion of subcommands.
    install_vim_plugin "hashivim/vim-terraform"

    install_vim_plugin "ctrlpvim/ctrlp.vim"

    install_vim_plugin "jeetsukumaran/vim-buffergator"


    ## install python libraries that the rope vim plugin will import
    ## https://github.com/python-rope/rope
    #sudo pip install rope ropevim

    ## install Vim plugin for rope python tools
    #install_vim_plugin "python-rope/ropevim"

    ## temporarily disabled because this requires a newer version of Ruby - should be easy to get working, if i actually want it
    #sudo gem install terraform_landscape

}

ERROR_MSG="ERROR: not all dev tools were installed!"

if is_macOS ; then
    install_mac || echo $ERROR_MSG

elif is_Linux ; then
    install_deb || echo $ERROR_MSG

fi

install_platform_agnostic || echo $ERROR_MSG
