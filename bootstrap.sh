# Use this file to (re)build a familiar command line env
# run "wget --no-check-certificate https://github.com/paulkiernan/dotfiles/raw/master/bootstrap.sh -O - | sh"

# Don't forget the SSH keys.
# Need to sudo to sucessfully apt-get

# Vars
dir=~/dotfiles
old_dir=~/dotfiles.old
files=".bashrc .gitconfig .tmux.conf .vim .vimrc"

echo "Creating the local directory for dotfiles"
mkdir ~/dotfiles/

# Install essential dev tools
echo "Installing essential dev tools"
sudo apt-get -y install vim git-core

# Install these dotfiles locally
echo "Cloning dotfiles repo from github"
git clone https://github.com/jasonventresca/dotfiles ~/dotfiles

# Back up existing dotfiles, and then symlink the new dotfiles
echo "Moving old dotfiles to $old_dir"
for file in $files; do
    mv ~/$file $old_dir
    echo "Creating symlink to $file in home directory"
    ln -s $dir/$file ~/$file
done

# Keep EC2 connections from periodically hanging up
echo "Configuring global SSH settings"
sudo echo "KeepAlive yes" >> /etc/ssh/sshd_config
sudo echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config

# Done!
echo "All done! Log out of all open sessions to install new env!"

