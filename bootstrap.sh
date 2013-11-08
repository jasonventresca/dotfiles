#!/bin/sh
set -eu

# Use this file to (re)build a familiar command line env
# run "wget --no-check-certificate https://github.com/jasonventresca/dotfiles/raw/master/bootstrap.sh -O - | sh"

# Don't forget the SSH keys.
# Need to sudo to sucessfully apt-get

# Vars
dir=$HOME/dotfiles/dotfiles
old_dir=$HOME/dotfiles.old
vim_mako_dirs="ftdetect indent syntax"
files="bashrc gitconfig tmux.conf vim vimrc"

# first install git
sudo apt-get install -y git-core

mkdir -p $HOME/dotfiles

# Install these dotfiles locally
echo "Cloning dotfiles repo from github"
git clone git@github.com:jasonventresca/dotfiles.git $HOME/dotfiles
git clone git://github.com/sophacles/vim-bundle-mako.git $HOME/dotfiles/vim-bundle-mako

echo "Installing dev tools"
$HOME/dotfiles/install_tools.sh

# Backup existing dotfiles, and then symlink the new dotfiles
echo "Moving old dotfiles to $old_dir"
mkdir -p $old_dir
for file in $files; do
    if [ -e $HOME/.$file ]; then
        mv $HOME/.$file $old_dir/.$file
    fi
    echo "Creating symlink $HOME/.$file  -->  $dir/$file"
    ln -s $dir/$file $HOME/.$file
done

# for Mac, symlink ~/.profile to point to ~/.bashrc
if [ -e $HOME/.profile ]; then
    mv .profile $old_dir/.profile # backup
    echo "Creating symlink $HOME/.profile --> $dir/bashrc"
    ln -s $dir/bashrc $HOME/.profile
fi


for subdir in $vim_mako_dirs; do
    file="/home/ubuntu/.vim/$subdir/mako.vim"
    if [ -e $file ]; then
        mkdir -p $old_dir/.vim/$subdir
        mv $file $old_dir/.vim/$subdir/mako.vim
    else
        mkdir -p /home/ubuntu/.vim/$subdir
    fi

    echo "Creating symlink $HOME/.vim/$subdir/mako.vim --> $HOME/dotfiles/vim-bundle-mako/$subdir/mako.vim"
    ln -s /home/ubuntu/dotfiles/vim-bundle-mako/$subdir/mako.vim $file
done


# Keep EC2 connections from periodically hanging up
echo "Configuring global SSH settings"
echo "KeepAlive yes" | sudo tee -a /etc/ssh/sshd_config
echo "ClientAliveInterval 60" | sudo tee -a /etc/ssh/sshd_config

cd $dir && git remote set-url origin git@github.com:jasonventresca/dotfiles.git

# Done!
echo "All done! Log out of all open sessions to finish installing new env!"

