#! /usr/bin/env bash

NOTES_PATH="$HOME/Notes/todo"

width="$2"

[ "$width" -le 100 ] && exit

[ -e "$NOTES_PATH" ] || exit

count=$(grep -Ec '^ *\* ' "$NOTES_PATH")

(( count > 0 )) && {
	(( count > 99 )) && count="+"
	printf " #[bg=$1,fg=black]  #[bg=terminal,fg=terminal] %s" "$count"
	exit
}

true
