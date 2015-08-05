#!/bin/bash
set -eu

REPO=$HOME/dotfiles.jason_ventresca

echo "Installing dev tools"
$REPO/install_tools.sh

cd $REPO && git remote set-url origin git@github.com:jasonventresca/dotfiles.git

if uname | grep -i darwin >/dev/null ; then
    echo "Mac OS X detected. Symlinking $HOME/.profile => $REPO/dotfiles/profile"
    rm -f $HOME/.profile
    ln -s $REPO/dotfiles/profile $HOME/.profile
fi

append_str='[[ -n $THIS_IS_JASON_VENTRESCA ]] && source $HOME/dotfiles.jason_ventresca/dotfiles/bashrc'
if ! grep -F "$append_str" $HOME/.bashrc >/dev/null ; then
    echo "Appending magic to $HOME/.bashrc..."
    echo $append_str >>$HOME/.bashrc
fi
