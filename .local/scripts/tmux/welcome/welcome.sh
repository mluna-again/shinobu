#! /usr/bin/env bash

declare WELCOME_PATH="$HOME/.local/scripts/tmux/welcome" RESPATH="$HOME/.local/scripts/tmux/welcome/.result"
declare run="${1:-0}" SCRIPT="$WELCOME_PATH/welcome.sh"

[ ! -f "$RESPATH" ] && touch "$RESPATH"
cd "$WELCOME_PATH"

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

	tmux list-sessions -F "#{session_name} #{session_last_attached} #{session_id}" | \
	  "$WELCOME_PATH/welcome" -width "$w" -height "$h" -result "$RESPATH" || exit 1

	tmux switch-client -t "$(cat "$RESPATH")"
}

if [ "$run" -eq 1 ]; then
	main
	exit
fi

tmux display-popup -w "100%" -h "100%" -EE "$SCRIPT 1"
