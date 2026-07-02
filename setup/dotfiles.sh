#!/bin/bash
set -eu

REPO=$HOME/dotfiles.jason_ventresca

source $REPO/util/platform.sh

# All symlinking (dotfiles, ssh config, macOS login-shell entry points)
# happens in one place. Re-run this directly to relink at any time.
$REPO/link_everything.sh

if is_Linux ; then
    append_str='[[ -n $LC_jason_ventresca || -n $AWS_jason_ventresca ]] && source $HOME/dotfiles.jason_ventresca/dotfiles/bashrc || source $HOME/.bashrc'
    if ! grep -F "$append_str" $HOME/.bash_profile >/dev/null ; then
        echo "Linux detected. Appending magic to $HOME/.bash_profile..."
        echo $append_str >>$HOME/.bash_profile

        echo "Appending the usage of .bashrc to .bash_profile, too..."
        echo "source $HOME/.bashrc" >>$HOME/.bash_profile
    fi
fi
