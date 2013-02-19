#!/bin/sh
# run as sudo
# Use this file to (re)link your dotfiles from ~/dotfiles/dotfiles to ~

# Vars
dir=~/dotfiles/dotfiles
old_dir=~/dotfiles.old
files="bashrc gitconfig tmux.conf vim vimrc"

for file in $files; do
  if [ -e ~/.$file ]; then
    mv ~/.$file $old_dir/.$file
  fi

  echo "Creating symlink ~/.$file  -->  $dir/$file"
  ln -s $dir/$file ~/.$file
done


