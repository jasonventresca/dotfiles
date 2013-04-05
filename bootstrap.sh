#!/bin/sh

# Use this file to (re)build a familiar command line env
# run "wget --no-check-certificate https://github.com/jasonventresca/dotfiles/raw/master/bootstrap.sh -O - | sh"

# Don't forget the SSH keys.
# Need to sudo to sucessfully apt-get

# Vars
dir=~/dotfiles/dotfiles
old_dir=~/dotfiles.old
vim_mako_dirs="ftdetect indent syntax"
files="bashrc gitconfig tmux.conf vim vimrc"
install_tools_script="~/dotfiles/install_tools.sh"

echo "Installing dev tools"
sh $install_tools_script

if [ ! -d ~/dotfiles ]; then
    mkdir ~/dotfiles
fi

# Install these dotfiles locally
echo "Cloning dotfiles repo from github"
git clone https://github.com/jasonventresca/dotfiles ~/dotfiles
git clone git://github.com/sophacles/vim-bundle-mako.git ~/dotfiles/vim-bundle-mako

# Back up existing dotfiles, and then symlink the new dotfiles
echo "Moving old dotfiles to $old_dir"
if [ ! -d $old_dir ]; then
    mkdir $old_dir
fi

for file in $files; do
    if [ -e ~/.$file ]; then
        mv ~/.$file $old_dir/.$file
    fi
    echo "Creating symlink ~/.$file  -->  $dir/$file"
    ln -s $dir/$file ~/.$file
done

for subdir in $vim_mako_dirs; do
    if [ -e ~/.vim/$subdir/mako.vim ]; then
        mv ~/.vim/$subdir/mako.vim $old_dir/.vim/$subdir/mako.vim
    fi
    echo "Creating symlink ~/dotfiles/vim-bundle-mako/$subdir/mako.vim  -->   ~/.vim/$subdir/mako.vim"
    ln -s ~/dotfiles/vim-bundle-mako/$subdir/mako.vim ~/.vim/$subdir/mako.vim
done


# Keep EC2 connections from periodically hanging up
echo "Configuring global SSH settings"
sudo echo "KeepAlive yes" >> /etc/ssh/sshd_config
sudo echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config

# Done!
echo "All done! Log out of all open sessions to finish installing new env!"

