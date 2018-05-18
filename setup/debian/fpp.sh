#!/bin/bash
set -eu

[[ -d /usr/local/PathPicker ]] && exit 0

cd /usr/local/
git clone https://github.com/facebook/PathPicker.git
ln -s /usr/local/PathPicker/fpp /usr/local/bin/fpp
