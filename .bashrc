# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# grep recursive with line numbers, case insensitive
alias grin='grep -Rin'

# some miscellaneous aliases
alias cdsp='cd /mnt/scrapepipeline/scrapepipeline'
alias cdweb='cd /mnt/codename/web'
alias cdlog='cd /mnt/log/apache2'
alias cdsd='cd /mnt/search-deployment'
alias cdmt='cd /mnt/moat/search/tasks/mturk'
alias apacherestart='sudo /etc/init.d/apache2 restart'
alias memcachedrestart='sudo /etc/init.d/memcached restart'
alias gencss='/mnt/codename/bin/generate_css.sh'
alias gencssa='/mnt/codename/bin/generate_css.sh; apacherestart'
alias cash='~/refresh_caches.sh'
alias warm_memcached='/mnt/common/scripts/glom_wrapper.sh python /mnt/scrapepipeline/scrapepipeline/potato/warm_memcache.py -e True -H localhost'

# git aliases
alias gits='git status'
alias gitsa='pushd .; cdweb; gits; cdsp; gits; popd;'
alias gitc='git commit -a'
alias gitco='git checkout'
alias gitd='git diff'
alias gitds='git diff --staged'
alias gitpm='pushd .; cdweb; git checkout master; git pull origin master; cdsp; git checkout master; git pull origin master; popd; gitsa' # pull master for both codename and scrapepipeline

# some common mysql commands
alias mysql_hosts='cat /mnt/scrapepipeline/scrapepipeline/potato/moat_hosts/MYSQL_HOSTS.py'
alias mysql_search='mysql search -u searchws -h db.moat.co -P 3306'
alias mysql_cache='mysql codename_cache_20120827 -u codename -h 127.0.0.1 -P 3307'
alias mysql_cache_nodb='mysql -u codename -h 127.0.0.1 -P 3307'
alias mysql_accounts='mysql codename_accounts -u codename -h 127.0.0.1 -P3307'
alias mysql_qa='mysql codename_qa -u codename -h 127.0.0.1 -P 3307'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

if [ -f /mnt/common/scripts/glom.sh ]; then
    . /mnt/common/scripts/glom.sh master.bots
fi

# set vim as default editor for stuff like git commit messages
export VISUAL=vim
export EDITOR=vim

