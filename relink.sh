#!/bin/sh
# run as sudo
# Use this file to (re)link your dotfiles from ~/dotfiles/dotfiles to ~

# Vars
dir=~/dotfiles.jason_ventresca/dotfiles
old_dir=~/dotfiles.old
files="gitconfig inputrc tmux.conf vim vimrc zshrc"

for file in $files; do
  if [ -e ~/.$file ]; then
    mv ~/.$file $old_dir/.$file
  fi

  echo "Creating symlink ~/.$file  -->  $dir/$file"
  ln -fs $dir/$file ~/.$file
done


