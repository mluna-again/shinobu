#!/bin/bash

if [ -z "$(tmux display -p '#{@zen_mode}')" ]; then
	exit
fi

width="$1"

[ "$width" -lt 100 ] && exit

printf " "
if uname | grep -i darwin &>/dev/null; then
	~/.local/scripts/osx/battery.sh "$@"
else
	~/.local/scripts/linux/battery.sh "$@"
fi
