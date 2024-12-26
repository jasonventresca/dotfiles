#!/bin/bash
set -eu

REPO=$HOME/dotfiles.jason_ventresca

source $REPO/util/platform.sh

if is_macOS ; then
    echo "Mac OS X detected. Symlinking $HOME/.bash_profile => $REPO/dotfiles/bash_profile"
    rm -f $HOME/.bash_profile
    ln -s $REPO/dotfiles/bash_profile $HOME/.bash_profile

elif is_Linux ; then
    append_str='[[ -n $LC_jason_ventresca || -n $AWS_jason_ventresca ]] && source $HOME/dotfiles.jason_ventresca/dotfiles/bashrc || source $HOME/.bashrc'
    if ! grep -F "$append_str" $HOME/.bash_profile >/dev/null ; then
        echo "Linux detected. Appending magic to $HOME/.bash_profile..."
        echo $append_str >>$HOME/.bash_profile

        echo "Appending the usage of .bashrc to .bash_profile, too..."
        echo "source $HOME/.bashrc" >>$HOME/.bash_profile
    fi
fi

