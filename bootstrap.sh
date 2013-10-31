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

# first install git
sudo apt-get install -y git-core

mkdir -p ~/dotfiles

# Install these dotfiles locally
echo "Cloning dotfiles repo from github"
git clone git@github.com:jasonventresca/dotfiles.git ~/dotfiles
git clone git://github.com/sophacles/vim-bundle-mako.git ~/dotfiles/vim-bundle-mako

echo "Installing dev tools"
~/dotfiles/install_tools.sh

# Backup existing dotfiles, and then symlink the new dotfiles
echo "Moving old dotfiles to $old_dir"
mkdir -p $old_dir
for file in $files; do
    if [ -e ~/.$file ]; then
        mv ~/.$file $old_dir/.$file
    fi
    echo "Creating symlink ~/.$file  -->  $dir/$file"
    ln -s $dir/$file ~/.$file
done

# for Mac, symlink ~/.profile to point to ~/.bashrc
if [ -e ~/.profile ]; then
    mv .profile $old_dir/.profile # backup
    echo "Creating symlink ~/.profile --> $dir/bashrc"
    ln -s $dir/bashrc ~/.profile
fi


# backup old ~/.vim folder and overwrite
if [ -e ~/.vim ]; then
    mv ~/.vim $old_dir/
    mkdir -p ~/.vim
fi

for subdir in $vim_mako_dirs; do
    echo "Creating symlink ~/dotfiles/vim-bundle-mako/$subdir/mako.vim  -->   ~/.vim/$subdir/mako.vim"
    mkdir -p ~/.vim/$subdir
    ln -s ~/dotfiles/vim-bundle-mako/$subdir/mako.vim ~/.vim/$subdir/mako.vim
done


# Keep EC2 connections from periodically hanging up
echo "Configuring global SSH settings"
echo "KeepAlive yes" | sudo tee -a /etc/ssh/sshd_config
echo "ClientAliveInterval 60" | sudo tee -a /etc/ssh/sshd_config

cd $dir && git remote set-url origin git@github.com:jasonventresca/dotfiles.git

# Done!
echo "All done! Log out of all open sessions to finish installing new env!"

