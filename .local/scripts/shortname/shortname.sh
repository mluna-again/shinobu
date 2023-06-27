#! /bin/bash

pat="~/.local/scripts/shortname"
osx() {
	[ ! -e "$pat/shortname_osx" ] && go build -C "$pat" -o "$pat/shortname_osx" &>/dev/null
	~/.local/scripts/shortname/shortname_osx "$@"
}

linux() {
	[ ! -e "$pat/shortname_linux" ] && go build -C "$pat" -o "$pat/shortname_linux" &>/dev/null
	~/.local/scripts/shortname/shortname_linux "$@"
}

if [ ! -z $(uname | grep -i darwin) ]; then
	osx "$@"
else
	linux "$@"
fi
