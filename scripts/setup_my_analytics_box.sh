#!/bin/bash
set -eu

# For any analytics I claim as a personal dev boxes (i.e. no one else is using it),
# this script makes it possible to use my custom git configuration without breaking
# the pre-commit hook in v2.5.

# The hook in ~/v2.5/.git/hooks/pre-commit does os.path.expanduser('~'), which
# gets the wrong value for $HOME since I've aliased to something that patches
# $HOME to $DOTFILES. Furthermore, we need to unalias vim as well, because when you
# run `git commit`, vim is opened, which would then also depend on $HOME having been
# patched in advance (as a child process of git).


echo "disabling wacky git and vim aliases in bashrc that re-point \$HOME"
sed -i \
    -e 's/\(alias git=.*\)/#\1 # Disabled by setup_my_analytics_box.sh/' \
    -e 's/\(alias vim=.*\)/#\1 # Disabled by setup_my_analytics_box.sh/' \
    -e 's/\(alias sudovim=.*\)/#\1 # Disabled by setup_my_analytics_box.sh/' \
    /home/ubuntu/dotfiles.jason_ventresca/dotfiles/bashrc


echo "symlink'ing git and vim dotfiles from home dir into jv's dotfiles repo"
ln -sf /home/ubuntu/dotfiles.jason_ventresca/dotfiles/gitconfig ~/.gitconfig
ln -sf /home/ubuntu/dotfiles.jason_ventresca/dotfiles/vimrc ~/.vimrc
rm -rf ~/.vim && ln -s /home/ubuntu/dotfiles.jason_ventresca/dotfiles/vim ~/.vim

echo "done :)"
echo
echo "now, you need to run the following from this shell (or just launch a fresh shell):"
echo "      unalias git"
echo "      unalias vim"
echo "      unalias sudovim"
