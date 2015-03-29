source $HOME/.profile

# Command completion
if [ -f /etc/bash_completion ]; then
        ./etc/bash_completion
fi

complete -cf sudo
complete -cf man

# Aliases
alias l='ls --color=auto -l'
alias la='ls --color=auto -la'
alias vi=vim

# Prompt
if [[ $EUID -ne 0 ]]; then
        if [ -n "$SSH_CLIENT"  ]; then
                host="\[\e[1;37m\]@\[\e[1;34m\]\H"
        else
                host=""
        fi
        export PS1="\[\e[1;34m\]\u${host} \[\e[1;37m\]\w\[\e[1;34m\] $ \[\e[m\]"
else
        if [ -n "$SSH_CLIENT"  ]; then
                host="\[\e[1;37m\]@\[\e[1;31m\]\H"
        else 
                host=""
        fi
        export PS1="\[\e[1;31m\]\u${host} \[\e[1;37m\]\w\[\e[1;31m\] $ \[\e[m\]"
fi

# Colorized manpages
man() {
        env LESS_TERMCAP_mb=$'\E[01;31m' \
        LESS_TERMCAP_md=$'\E[01;38;5;74m' \
        LESS_TERMCAP_me=$'\E[0m' \
        LESS_TERMCAP_se=$'\E[0m' \
        LESS_TERMCAP_so=$'\E[38;5;246m' \
        LESS_TERMCAP_ue=$'\E[0m' \
        LESS_TERMCAP_us=$'\E[04;38;5;146m' \
        man "$@"
}

