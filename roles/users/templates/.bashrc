#!/usr/local/bin/bash

export PKG_PATH=http://ftp.openbsd.org/pub/OpenBSD/$(uname -r)/packages/amd64/

HISTTIMEFORMAT="%y/%m/%d %T "

#################
### FUNCTIONS ###
#################

function getPS1 {
if [[ $(pwd) == $HOME ]]; then
    echo " ~"
else
    pwd | awk -F\/ '{print $(NF-1),$(NF)}' | sed -e 's, ,/,g'
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

function pflog() {
    doas tcpdump -e -ttt -r /var/log/pflog
}

function pflog0() {
    doas tcpdump -e -ttt -i pflog0
}

#################
### Setup PS1 ###
#################

export PS1='[\[\e[44m\]\u@\h\[\e[0m\]\[\e[44m\]\[\e[0m\] $(getPS1)]# '

shopt -s histappend
LS_COLORS=$LS_COLORS'di=0;33:ex=0;32:' ; export LS_COLORS

########################
### Personal Aliases ###
########################

alias ll="ls -halp"
alias ls="colorls -F"
alias cp="cp -i"
alias vir="vi -R"
alias gs="git status"
alias gd="git diff"
alias gpl="git pull"
alias gb="git branch | sed '/^$/d'"
alias vi="vim"
alias rm="rm -i"

function gp {
    branch=$(git branch | grep '\*' | awk '{print $NF}')
    git push origin $branch
}
