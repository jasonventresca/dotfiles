#!/bin/sh
set -eu

# dev tools
tools='vim git-core tig tmux build-essential bash-completion sl curl ipython python-setuptools python-dev python-pip'
error_msg="ERROR: at least of the following were not installed: $tools"
sudo apt-get install -y $tools || echo $error_msg

