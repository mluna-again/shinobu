#!/bin/bash

width="$1"

[ "$width" -lt 100 ] && exit

if uname | grep -i darwin &>/dev/null; then
	~/.local/scripts/osx/battery.sh "$@"
else
	~/.local/scripts/linux/battery.sh "$@"
fi
