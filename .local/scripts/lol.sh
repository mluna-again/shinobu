#! /usr/bin/env bash

trap exit INT

command -v lolcat &>/dev/null || { printf "lolcat not installed." ; exit 1 ; }
command -v figlet &>/dev/null || { printf "figlet not installed." ; exit 1 ; }

font="${2:-$HOME/.local/fonts/ansi.flf}"
height=$(tput lines)
width=$(tput cols)
vert_padding=$(( (height-8) / 2 ))

# hide cursor
printf "\033[?25l"

input="$1"
while true; do
	text=$(figlet -w "$width" -c -f "$font" "$input" | lolcat --force)
	clear
	for (( i=0; i<vert_padding; i++ )) {
		printf "\n"
	}

	printf "%s\n" "$text"

	sleep 1
done

clear
