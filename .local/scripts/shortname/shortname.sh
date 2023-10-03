#! /bin/bash

_session_path="$1"
width="$2"
background="$3"
session_name="$4"

[ "$width" -lt 100 ] && exit

pat="$HOME/.local/scripts/shortname"
osx() {
	[ ! -e "$pat/shortname_osx" ] && go build -C "$pat" -o "$pat/shortname_osx" &>/dev/null
	~/.local/scripts/shortname/shortname_osx "$@"
}

linux() {
	[ ! -e "$pat/shortname_linux" ] && go build -C "$pat" -o "$pat/shortname_linux" &>/dev/null
	~/.local/scripts/shortname/shortname_linux "$@"
}

if uname | grep -i darwin &>/dev/null; then
	output=$(osx "$@")
else
	output=$(linux "$@")
fi

printf "#[fg=black,bg=%s] 󰉋 #[bg=terminal,fg=terminal] %s :: %s " "$background" "$output" "$session_name"
