#!/bin/bash
set -eu

HOST=$1

#ssh -o PermitLocalCommand=no ubuntu@$HOST 'echo "login from jason at $(date)" >>~/jason_logins.txt'
ssh -o PermitLocalCommand=no ubuntu@$HOST 'wget --no-check-certificate https://github.com/jasonventresca/dotfiles/raw/master/bootstrap.sh -O - | sh'
