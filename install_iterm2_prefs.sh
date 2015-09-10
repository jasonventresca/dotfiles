#!/bin/bash
set -eux

# iTerm2 not taking newly installed plist?
#   http://apple.stackexchange.com/a/111559

cp ~/dotfiles.jason_ventresca/other_dotfiles/com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist
