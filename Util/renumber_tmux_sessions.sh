#!/bin/sh
sessions=$(tmux ls | grep '^[0-9]\+:' | cut -f1 -d':' | sort -n)

new=0
for session in $sessions; do
	tmux rename -t $session $new
	new=$(($new + 1))
done
