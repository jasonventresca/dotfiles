#!/bin/bash
set -eu

REPO=$HOME/dotfiles.jason_ventresca
RAW_SRC_URL='https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy'
TARGET="${REPO}/bin/diff-so-fancy"

curl \
    "${RAW_SRC_URL}" \
    1>"${TARGET}" \
    2>/dev/null

chmod u+x "${TARGET}"
