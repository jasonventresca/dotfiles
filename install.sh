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

echo "[[ -n \$LC_jason_ventresca ]] && source \$HOME/dotfiles.jason_ventresca/dotfiles/bashrc" >>$HOME/.bashrc

echo "All done! Log out of all open sessions to finish installing new env!"
