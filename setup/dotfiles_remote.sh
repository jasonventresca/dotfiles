#!/bin/bash
set -eu

HOST="${1}"
PORT="${2}"
shift
shift
SSH_OPTS="${@:-}"

BOOTSTRAP_SCRIPT_URL='https://github.com/jasonventresca/dotfiles/raw/master/bootstrap.sh'

ssh \
    -o PermitLocalCommand=no \
    ${SSH_OPTS} \
    ubuntu@${HOST} -p ${PORT} \
    "wget --no-check-certificate ${BOOTSTRAP_SCRIPT_URL} -O - | bash"
