#!/bin/sh
set -eu

dir=$HOME/dotfiles/dotfiles
old_dir=$HOME/dotfiles.old

echo "Installing dev tools"
$HOME/dotfiles/install_tools.sh

cd $dir && git remote set-url origin git@github.com:jasonventresca/dotfiles.git

# Done!
echo "All done! Log out of all open sessions to finish installing new env!"

