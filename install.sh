#!/bin/sh
set -eu

DOTFILES=$HOME/dotfiles/dotfiles

echo "Installing dev tools"
$DOTFILES/../install_tools.sh

cd $DOTFILES && git remote set-url origin git@github.com:jasonventresca/dotfiles.git

echo "All done! Log out of all open sessions to finish installing new env!"
