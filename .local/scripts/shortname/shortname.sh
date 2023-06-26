#! /bin/bash

osx() {
	[ ! -e ./shortname_osx ] && go build -o shortname_osx &>/dev/null
	./shortname_osx "$@"
}

linux() {
	[ ! -e ./shortname_linux ] && go build -o shortname_linux &>/dev/null
	./shortname_linux "$@"
}

if [ ! -z $(uname | grep -i darwin) ]; then
	osx "$@"
else
	linux "$@"
fi
