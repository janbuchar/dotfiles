alias l='ls --color=auto -l'
alias la='ls --color=auto -la'
alias vi=vim

if [[ $EUID -ne 0 ]]; then
        if [ -n "$SSH_CLIENT"  ]; then
                host="\[\e[1;37m\]@\[\e[1;34m\]\H"
        else
                host=""
        fi
        export PS1="\[\e[1;34m\]\u${host} \[\e[1;37m\]\w\[\e[1;34m\] $ \[\e[1;37m\]"
else
        if [ -n "$SSH_CLIENT"  ]; then
                host="\[\e[1;37m\]@\[\e[1;31m\]\H"
        else 
                host=""
        fi
        export PS1="\[\e[1;31m\]\u${host} \[\e[1;37m\]\w\[\e[1;31m\] $ \[\e[1;37m\]"
fi
