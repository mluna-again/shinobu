#! /bin/sh

if uname | grep -i darwin &>/dev/null; then
	~/.local/scripts/osx/init.sh
else
	~/.local/scripts/linux/init.sh
fi
