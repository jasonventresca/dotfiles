# Use this file to (re)build a familiar command line env
# run "wget --no-check-certificate https://github.com/jasonventresca/dotfiles/raw/master/bootstrap.sh -O - | sh"

# Don't forget the SSH keys.
# Need to sudo to sucessfully apt-get

# Vars
dir=~/dotfiles/dotfiles
old_dir=~/dotfiles.old
files="bashrc gitconfig tmux.conf vim vimrc"

echo "Installing essential dev tools"
sudo apt-get -y install vim git-core curl tmux


if [ ! -d ~/dotfiles ]; then
    mkdir ~/dotfiles
fi

# Install these dotfiles locally
echo "Cloning dotfiles repo from github"
git clone https://github.com/jasonventresca/dotfiles ~/dotfiles

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

# Keep EC2 connections from periodically hanging up
echo "Configuring global SSH settings"
sudo echo "KeepAlive yes" >> /etc/ssh/sshd_config
sudo echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config

# Done!
echo "All done! Log out of all open sessions to finish installing new env!"

