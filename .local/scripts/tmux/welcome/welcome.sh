#! /usr/bin/env bash

declare WELCOME_PATH="$HOME/.local/scripts/tmux/welcome" RESPATH="$HOME/.local/scripts/tmux/welcome/.result"
declare run="${1:-0}" SCRIPT="$WELCOME_PATH/welcome.sh"

cd "$WELCOME_PATH"

terror() { tmux display -d 0 "#[bg=#{@color_error},fill=#{@color_error},fg=black]  Message: $*"; }

[ ! -f "$RESPATH" ] && touch "$RESPATH"
: > "$RESPATH"

binary_exists() {
	[ -x "$WELCOME_PATH/welcome" ]
}

go_installed() {
	command -v go &>/dev/null
}

compile_welcome() {
	echo "Compiling Welcome Screen..."
	go build || return 1
	clear
}

main() {
	if ! binary_exists && ! go_installed; then
		echo "Welcome Screen is not compiled and you don't have go :("
		exit
	fi

	if ! binary_exists; then
		if ! compile_welcome; then
			echo "Failed at compiling Welcome Screen D:"
			exit
		fi
	fi

	h=$(tput lines)
	w=$(tput cols)

	tmux list-sessions -F "#{session_name} #{session_windows} #{session_id}" | \
		"$WELCOME_PATH/welcome" -width "$w" -height "$h" -result "$RESPATH" -quote "$(fortune -s)" || exit 1

	id="$(cat "$RESPATH")"
	[ -z "$id" ] && exit

	case "$id" in
		"@detach")
			tmux detach
			exit
			;;

		"@disconnect")
			pid="$(ps aux | grep -E "sshd: [a-zA-Z0-9]+@" | awk '{print $2}')"
			if [ -z "$pid" ]; then
				terror "Could not find sshd pid, are you in a SSH session?"
				exit
			fi
			kill "$pid"
			;;

		*)
			tmux switch-client -t "$id"
			;;
	esac
}

if [ "$run" -eq 1 ]; then
	main
	exit
fi

tmux display-popup -w "100%" -h "100%" -EE "$SCRIPT 1"
