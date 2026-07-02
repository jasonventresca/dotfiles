# Shell-agnostic aliases, functions and exports, shared by bashrc (bash) and
# zshrc (zsh). Keep anything bash-only in bashrc and anything zsh-only in zshrc.

DOT_JV='dotfiles.jason_ventresca'
export DOTFILES=$HOME/$DOT_JV/dotfiles
export PATH="$HOME/$DOT_JV/bin":"$PATH"
export PATH="$HOME/.local/bin":"$PATH"
export AWS_PROFILE=default-mfa

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'
fi

alias grep='grep --color=auto'
alias cgrep='grep --color=always'
alias g="grep -rI --exclude-dir={node_modules,.webassets-cache,.git} --exclude=\*.tfstate\*"
alias grep_src=g

# some more ls aliases
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias lf='ll | grep "^-"' # files
alias ld='ll | grep "^d"' # directories


# some miscellaneous aliases
alias source-bashrc='source $DOTFILES/bashrc'
alias source-zshrc='source $DOTFILES/zshrc'
if [ -n "${ZSH_VERSION:-}" ]; then
    alias source-rc='source $DOTFILES/zshrc'
else
    alias source-rc='source $DOTFILES/bashrc'
fi
alias dotfiles-reload='git -C $DOTFILES pull origin master && source-rc'
alias instance_id='curl "http://169.254.169.254/latest/meta-data/instance-id"'
alias fact="elinks -dump randomfunfacts.com | sed -n '/^| /p' | tr -d \|"
alias tmux="TERM=screen-256color-bce tmux -f $DOTFILES/tmux.conf"
alias tmux-set-scrollback='tmux set-option -g history-limit' # e.g. tmux-set-scrollback 1000
alias tmux-get-scrollback='tmux show-options -g | grep history-limit'
alias ufilext='xargs -n1 basename | cut -d. -f2 | sort | uniq' # unique file extensions among a list of file paths, e.g. $ grep -rl 'DBSession' $REPOS | ufilext

# JSON pretty-print utility
alias jsonp='python -mjson.tool'

# cat file with syntax-highlighting. the -g attempts to guess the lexer from the file contents
alias pcat='pygmentize -g'

alias epoch='date +%s'

alias svc-which='ps aux | grep -i -e apache -e python -e couch -e memcache -e mysql -e postgres -e pgpool -e nrpe -e nagios -e nginx -e redis -e que -e ruby -e god -e redsocks -e vim -e emacs -e tmux -e rabbit'

# git aliases
alias git="HOME=$DOTFILES git"
alias gits='git status'
alias gitsa='pushd .; cdmp; gits; popd;'
alias gitc='git commit'
alias gitco='git checkout'
alias gitd='git diff --find-renames'
alias gitds='git diff --staged --find-renames'
alias gitdh='git diff HEAD'
# git diff without `diff-so-fancy` (e.g. if you want to parse the output of git diff)
alias git-plain-diff='git -c pager.log=less -c pager.show=less -c pager.diff=less'


# ssh aliases
alias scp='scp -o PermitLocalCommand=no'
alias nssh='ssh -o PermitLocalCommand=no'


function md() {
    markserv $@ -l
}

# parallel-ssh/scp aliases
PSSH_ARGS='-v -p8 --timeout=10 -O PermitLocalCommand=no -O StrictHostKeyChecking=no'
alias pssh="parallel-ssh -i ${PSSH_ARGS}"
alias pscp="parallel-scp ${PSSH_ARGS}"
alias psshp="parallel-ssh -i ${PSSH_ARGS} ${PRO_GW_ARGS}"
alias pscpp="parallel-scp ${PSSH_ARGS} ${PRO_GW_ARGS}"

alias vshield-stop='sudo /usr/local/McAfee/AntiMalware/VSControl stopoas'
alias vshield-start='sudo /usr/local/McAfee/AntiMalware/VSControl startoas'

alias tf='terraform'
alias tfp='tf validate && tf fmt && tf plan -out=tfplan'
alias tfpl='tf validate && tf fmt && tf plan -out=tfplan | landscape'
function tfpt { tf plan -target="$1" -out=tfplan; }
function tfptl { tf plan -target="$1" -out=tfplan | landscape; }

function edit-config() {
    # for editing dotfiles
    local config_file=$1
    vim $DOTFILES/$config_file
}

ssh_agent_ps=$(ps x | grep ssh-agent | grep -v grep | awk '{ print $1 }')
if [ -z "$ssh_agent_ps" ]; then
   eval `ssh-agent -s`
else
   export SSH_AGENT_PID=$ssh_agent_ps
fi

# aliases for obtaining external and internal ip
alias ip-ext='curl https://jsonip.com 2>/dev/null | sed '"'"'s/.*"\([0-9.]*\)".*/\1\n/'"'"''
alias ip-int='ifconfig | grep --color=never -o "inet addr:10[^ ]*" | grep --color=never -o "10.*"'

# aliases for sourcing AWS IAM User keys and other secrets
alias itsme="source $HOME/.secrets.sh"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# set vim as default editor for stuff like git commit messages
export VISUAL=vim
export EDITOR=vim
alias vim='REAL_HOME=$HOME HOME=$DOTFILES vim'
alias sudovim='sudo REAL_HOME=$HOME HOME=$DOTFILES vim'


function latest() {
    ls -lht $1 | head -n 1 | awk '{print $9}'
}

# Ready-to-use <Tab> character via ANSI C quoting (see http://askubuntu.com/a/53096)
export T=$'\t'

function jira-tabs-print () {
    latest_tabs_export=$(ls -t $HOME/Downloads/cluster-windows*json | head -1)

    cat "${latest_tabs_export}" \
        | jq --raw-output '.[].tabs[] | (.url + " - " + .title)'
}

function ssh-reagent () {
    export SSH_AUTH_SOCK=$( find /tmp/ssh-* -user `whoami` -name agent\* -printf '%T@ %p\n' 2>/dev/null | \
                            sort -k 1 -nr | sed 's/^[^ ]* //' | head -n 1 )
    if ssh-add -l 2>&1 >/dev/null ; then
        echo "Found working SSH Agent:"
        ssh-add -l
    else
        echo "Cannot find ssh agent - maybe you should reconnect and forward it?"
    fi
}

function pssh-results () {
    local results_file="$1" # e.g. ~/pssh.txt
    if [[ -z $results_file ]] ; then
        results_file=$HOME/pssh.txt
    fi
    echo "success: $(grep -c SUCCESS $results_file)"
    echo "failure: $(grep -c FAILURE $results_file)"
}

function rebase() {
    n_commits="$1"
    echo "rebasing last $n_commits commits... (replace 'pick' with 'fixup' or 'squash')"
    sleep 1
    git rebase -i $(git rev-parse HEAD~${n_commits})
}

function dusort() {
    sudo du -sh $@ 2>/dev/null | sort -hr
}

function join-lines() {
    local replacement="$1"
    sed -e ':a' -e 'N' -e '$!ba' -e "s/\\n/${replacement}/g"
}

function grep_multi() {
    # Ex: cat data.txt | grep_multi one two three
    #  => cat data.txt | grep -e one -e two -e three
    local cmd='grep'
    local pattern
    for pattern in "$@"; do
        cmd="$cmd -e $pattern"
    done
    eval "$cmd"
}

function h() {
    # Is the supplied argument an IP address?
    if echo $@ | grep -E '^[0-9.]+$' >/dev/null ; then
        pls_ec2 | grep $@ | cut -f 2
        return
    fi

    # If it's not an IP address, let's assume it's a DNS name that we can lookup.
    local res=$(nslookup $@ | grep Address | tail -n1 | cut -f 2 -d ' ')
    if echo $res | grep '^10\.' >/dev/null ; then
        echo $res
    else
        pls_ec2 | grep $res | cut -f 2
    fi
}

function man() {
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;31m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
            man "$@"
}


function decode-aws-auth-failure-message {
    if [ $# -ne 1 ] || [ "$1" = -h ] || [ "$1" = --help ]; then
        cat <<'EOT'
Usage: decode-authorization-failure-message <message>
Use this when Amazon gives you an "Encoded authorization failure message" and
you need to turn it into something readable.
EOT
        return 1
    fi

    aws sts decode-authorization-message --encoded-message "$1" |
        jq '.["DecodedMessage"]' |
        sed 's/\\"/"/g' |
        sed 's/^"//' |
        sed 's/"$//' |
        jsonp
}

function ivim() {
    vim - -c "setl filetype=$1"
}

function grep_py_imports() {
    local ident=$1
    shift
    local grep_args=$@

    grep_src \
        -e "import.*${ident}" \
        -e "${ident}.*import" \
        $grep_args
}

function py-ctags() {
    find $@ -name "*.py" | ctags-exuberant -L - --language-force=python -f $HOME/.py-ctags
}

function s3-first() {
    # Either of these are acceptable:
    #     s3-first s3://search-archives/hello.txt
    #     s3-first hello.txt
    # But this is not (only supports the search-archives bucket):
    #     s3-first s3://some-other-bucket/foo.txt

    local prefix_uri="$1"
    shift
    local bucket='s3://search-archives/'
    if \
            echo $prefix_uri | grep "^${bucket}" >/dev/null || \
            ! echo $prefix_uri | grep "^s3://" >/dev/null
    then
        if ! echo $prefix_uri | grep "^s3://" >/dev/null ; then
            prefix_uri=${bucket}${prefix_uri}
        fi
        local first_line=$(aws s3 ls --recursive ${prefix_uri} | head -n1)
        local first_s3_key=$(echo $first_line | awk '{print $4}')
        echo "(stderr) first s3 object is: ${first_line}" 1>&2
        aws s3 cp ${bucket}${first_s3_key} $@
    else
        echo "FATAL: This bash function assumes you are using the ${bucket} bucket."
    fi
}

function header() {
    # example:
    # $ cat data.tsv | header sort -k3 -nr
    read -r
    printf "%s\n" "$REPLY"
    $@
}

function tsv_delete_column() {
    # Delete the n'th column from a delimited stream (default is tab-delimited)
    # See https://stackoverflow.com/a/12717796/2503100
    local col_num="$1"
    local delim="${2:-$T}"
    cat | sed "s/[^${delim}]*${delim}//${col_num}"

}

export SUBLIME_APP='/Applications/Sublime Text.app'
alias subl_open="open -a \"${SUBLIME_APP}\""
export d='/mnt/data'

function fetch-repos() {
    local repo

    for repo in "$@"; do
        cd "${repo}"
        echo "fetching ${repo} ..."
        git fetch >/dev/null
    done
    echo "--- success! ---"
}

if [ -f $HOME/dev/hubble/commands.sh ]
then
    source $HOME/dev/hubble/commands.sh
fi

alias cd-ps='cd $HOME/dev/podcast-sharing-app/backend-api'
alias cd-dea='cd $HOME/dev/deep-end/deepend-agent'
alias cd-deb='cd $HOME/dev/deep-end/deepend-agent/src/deepend_backend'
alias cd-des='cd $HOME/dev/deep-end/deepend-agent/src/deepend_backend/secrets'
alias de-todos="grep -rI 'TODO' $HOME/dev/deep-end/deepend-agent/src/{deepend_backend,tests}"
alias de-todo-categories="grep -rI '### TODO' /Users/jasonventresca/dev/deep-end/deepend-agent/README.md | grep -o 'TODO.*'"
alias grep-js="grep --exclude-dir={.next,.git,node_modules}"
alias grep-py="grep --exclude-dir=.pytest_cache"
alias cleanup-merged-branches="$HOME/dev/git-tools/cleanup-merged-branches.sh"

alias cld='claude --permission-mode auto --resume'

# Git Worktrees
alias wt='git worktree'
function cd-wt() {
    cd "${HOME}/dev/git-worktrees/${1}"
}


# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/jasonventresca/.lmstudio/bin"

# DuckDB - https://duckdb.org/docs/installation/
export PATH='/home/ubuntu/.duckdb/cli/latest':$PATH

# Poetry
export PATH="/home/ubuntu/.local/bin:$PATH"
