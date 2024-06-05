#! /bin/bash

if ! command -v shortname &>/dev/null; then
	echo shortname not compiled
	exit
fi

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

output=$(shortname "$_session_path" "$width" "$background" "$session_name")

output=$(sed 's|/$||' <<< "$output")
printf "#[fg=black,bg=%s] 󰉋 #[bg=terminal,fg=terminal] %s " "$background" "$output"
if [ -n "$session_name" ] && [ -z "$(tmux display -p '#{@zen_mode}')" ]; then
	printf ":: %s " "$session_name"
fi

true
