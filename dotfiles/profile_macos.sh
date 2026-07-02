# Mac-specific login-shell configuration, shared by bash_profile (bash) and
# zprofile (zsh).

eval "$(/opt/homebrew/bin/brew shellenv)"

alias parallel-ssh="$(which pssh)"
alias parallel-scp="$(which pscp)"

export LC_jason_ventresca=yes
export AWS_jason_ventresca=yes

[ -f $HOME/.ssh/id_ed25519_02-Dec-2024 ] && ssh-add --apple-use-keychain $HOME/.ssh/id_ed25519_02-Dec-2024
[ -f $HOME/.ssh/candor ] && ssh-add --apple-use-keychain $HOME/.ssh/candor
[ -f $HOME/.ssh/personal ] && ssh-add --apple-use-keychain $HOME/.ssh/personal

# Short of learning how to actually configure OSX, here's a hacky way to use
# GNU manpages for programs that are GNU ones, and fallback to OSX manpages otherwise.
# See https://gist.github.com/quickshiftin/9130153 for more info.
alias man='_() { echo $1; man -M $(brew --prefix)/opt/coreutils/libexec/gnuman $1 1>/dev/null 2>&1;  if [ "$?" -eq 0 ]; then man -M $(brew --prefix)/opt/coreutils/libexec/gnuman $1; else man $1; fi }; _'

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/jasonventresca/.lmstudio/bin"
export PATH="/opt/homebrew/opt/postgresql@18/bin:$PATH"
