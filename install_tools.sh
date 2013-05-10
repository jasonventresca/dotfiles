#!/bin/sh
set -eux

# dev tools
sudo apt-get install -y vim git-core tig tmux build-essential bash-completion sl curl 
sudo apt-get -y install 

# node.js
sudo apt-get install -y python-software-properties python g++ make
sudo add-apt-repository -y ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install -y nodejs

# python tools
sudo apt-get install ipython python-setuptools python-dev python-pip pygmentize

