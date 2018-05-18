#!/bin/bash
set -eu

HOST=$1
PORT=$2

ssh -o PermitLocalCommand=no ubuntu@$HOST -p $PORT 'wget --no-check-certificate https://github.com/jasonventresca/dotfiles/raw/master/bootstrap.sh -O - | bash'
