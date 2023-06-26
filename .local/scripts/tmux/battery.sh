#!/bin/sh

if [ ! -z $(uname | grep -i darwin) ]; then
	~/.local/scripts/osx/battery.sh "$@"
else
	~/.local/scripts/linux/battery.sh "$@"
fi
