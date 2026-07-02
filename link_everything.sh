#!/bin/bash
# (Re)link all dotfiles from this repo into $HOME. Idempotent — safe to
# re-run any time. Pre-existing real files (not symlinks) are backed up to
# ~/dotfiles.old before being replaced.
set -eu

REPO=$HOME/dotfiles.jason_ventresca

source $REPO/util/platform.sh

old_dir=$HOME/dotfiles.old
mkdir -p $old_dir

link() {
    local src=$1
    local dest=$2

    if [ -L $dest ]; then
        rm $dest
    elif [ -e $dest ]; then
        mv $dest $old_dir/$(basename $dest)
    fi

    echo "Creating symlink $dest  -->  $src"
    ln -s $src $dest
}

# dotfiles that live directly in $HOME, on all platforms
for file in gitconfig inputrc tmux.conf vim vimrc bashrc zshrc; do
    link $REPO/dotfiles/$file $HOME/.$file
done

# ssh config
mkdir -p $HOME/.ssh
link $REPO/other_dotfiles/ssh-config $HOME/.ssh/config

# login-shell entry points (macOS only; on Linux, setup/dotfiles.sh appends
# a guarded source line to ~/.bash_profile instead of symlinking it)
if is_macOS ; then
    for file in bash_profile zprofile; do
        link $REPO/dotfiles/$file $HOME/.$file
    done
fi
