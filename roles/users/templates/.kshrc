# NAME:
#	ksh.kshrc - global initialization for ksh
#
# DESCRIPTION:
#	Each invocation of /bin/ksh processes the file pointed
#	to by $ENV (usually $HOME/.kshrc).
#	This file is intended as a global .kshrc file for the
#	Korn shell.  A user's $HOME/.kshrc file simply requires
#	the line:
#		. /etc/ksh.kshrc
#	at or near the start to pick up the defaults in this
#	file which can then be overridden as desired.

# we may have su'ed so reset these
USER=$(id -un)
UID=$(id -u)
HOSTNAME=$(hostname -s)
PROMPT='[${USER}@${HOSTNAME} $(getPWD)]# '
PS1=$PROMPT
HISTTIMEFORMAT="%y/%m/%d %T "
HISTFILE="$HOME/.ksh_history"
HISTSIZE=5000

# $console is the system console device
console=$(sysctl kern.consdev)
console=${console#*=}

set -o emacs

LS_COLORS=$LS_COLORS'di=0;33:ex=0;32:' ; export LS_COLORS

alias cdr="cd /root"
alias ll="ls -halp"
alias cp="cp -i"
alias vir="vi -R"
alias gs="git status"
alias gd="git diff"
alias gpl="git pull"
alias gb="git branch | sed '/^$/d'"
alias vi="vim"
alias rm="rm -i"
alias df='df -h'
alias du='du -h'
alias ls='ls -F'


#################
### FUNCTIONS ###
#################

function getPWD {
    cwd=$(pwd)
    if [[ $cwd == $HOME ]]
    then
        echo -n '~'
    else
        echo -n $cwd | awk -F\/ '{print $(NF-1),$(NF)}' | sed -e 's, ,/,g'
    fi
}

function errata {
    curl -s https://www.openbsd.org/errata65.html | grep FIX | awk -F\> '{print $2}' | awk -F\< '{print $1}'
}

function upload {
    if [[ -e $1 ]]; then
        cat $1 | mail -s "$(date) Uploading: $1" circa.1991@gmail.com
    else
        echo "Please specify file to upload via cat $1 | mail..."
    fi
}

function watch {
    count=0
    if [[ -z $1 ]]; then
        echo "Please specify command to watch"
    else
        while true
        do
            if [[ $count == 0 ]]; then
                clear
            fi
            echo "Running $*: $(date)"
            echo
            echo "$($*)" | tail -30
            sleep 2
            clear
        done
    fi
}

function pflog {
    doas tcpdump -e -ttt -r /var/log/pflog
}

function pflog0 {
    doas tcpdump -e -ttt -i pflog0
}

function console {
    echo 'Exit with "~ ctrl + d"'
    doas cu -l /dev/cuaU0
}

function gp {
    branch=$(git branch | grep '\*' | awk '{print $NF}')
    git push origin $branch 
}
