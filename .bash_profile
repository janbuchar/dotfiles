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
white="1;37m"

if [ $EUID -ne 0 ]; then
	color="1;34m"
else
	color="1;31m"
fi

if [ -n "$SSH_CLIENT" ]; then
	host="\[\e[$white\]@\[\e[$color\]\H"
else
	host=""
fi

if [ "$TERM" == "screen" ]; then
	host="${host} \[\e[$white\](screen)"
fi

export PS1="\[\e[$color\]\u${host} \[\e[$white\]\w\[\e[$color\] $ \[\e[m\]"

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

# Make dir and change to it
mkcd() {
	mkdir "$*"
	cd "$*"
}
