#! /bin/bash

_session_path="$1"
width="$2"
background="$3"
session_name="$4"
force="$5"
[ "$width" -le 100 ] && [ -z "$force" ] && exit

if grep -vq '/' <<< "$_session_path"; then
	printf "#[fg=black,bg=%s]  #[bg=terminal,fg=terminal] %s " "$background" "$_session_path"
	exit
fi

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

output=$(sed 's|/$||' <<< "$output")
printf "#[fg=black,bg=%s] 󰉋 #[bg=terminal,fg=terminal] %s " "$background" "$output"
if [ -n "$session_name" ] && [ -z "$(tmux display -p '#{@zen_mode}')" ]; then
	printf ":: %s " "$session_name"
fi

true
