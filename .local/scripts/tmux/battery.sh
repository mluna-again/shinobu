#!/bin/sh

[ "$1" -lt 100 ] && { exit; }

if [ ! -z "$(uname | grep -i darwin)" ]; then
	~/.local/scripts/osx/battery.sh "$@"
else
	~/.local/scripts/linux/battery.sh "$@"
fi
