#!/bin/sh

if [ $(tmux ls | wc -l) -le 1 ] && tmux has-session -t 0 > /dev/null; then
	$(tmux show-options -g | grep @resurrect-restore-script-path | cut -f 2 -d " " | tr -d '"''"')
fi

