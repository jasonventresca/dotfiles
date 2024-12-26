#!/bin/bash
set -eux

REPO="$HOME/dotfiles.jason_ventresca"

echo "Installing dev tools..."
$REPO/setup/dev_tools.sh

echo "Installing dotfiles..."
$REPO/setup/dotfiles.sh

echo "OK, done!"
