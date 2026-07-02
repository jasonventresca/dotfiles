#!/bin/bash
set -eu

REPO=$HOME/dotfiles.jason_ventresca

source $REPO/util/platform.sh

if is_macOS ; then
    echo "Mac OS X detected. Symlinking bash and zsh entry points..."
    old_dir=$HOME/dotfiles.old
    mkdir -p $old_dir
    for file in bash_profile zprofile zshrc; do
        # back up any pre-existing real file (not a symlink) before replacing it
        if [ -e $HOME/.$file ] && [ ! -L $HOME/.$file ]; then
            mv $HOME/.$file $old_dir/.$file
        fi
        echo "Symlinking $HOME/.$file => $REPO/dotfiles/$file"
        rm -f $HOME/.$file
        ln -s $REPO/dotfiles/$file $HOME/.$file
    done

elif is_Linux ; then
    append_str='[[ -n $LC_jason_ventresca || -n $AWS_jason_ventresca ]] && source $HOME/dotfiles.jason_ventresca/dotfiles/bashrc || source $HOME/.bashrc'
    if ! grep -F "$append_str" $HOME/.bash_profile >/dev/null ; then
        echo "Linux detected. Appending magic to $HOME/.bash_profile..."
        echo $append_str >>$HOME/.bash_profile

        echo "Appending the usage of .bashrc to .bash_profile, too..."
        echo "source $HOME/.bashrc" >>$HOME/.bash_profile
    fi
fi

