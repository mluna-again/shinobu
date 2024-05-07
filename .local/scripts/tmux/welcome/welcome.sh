#! /usr/bin/env bash

if [ -n "$NVIM" ]; then
	exit
fi

declare WELCOME_SESSION="__WELCOME__"

declare WELCOME_PATH="$HOME/.local/scripts/tmux/welcome" RESPATH="$HOME/.local/scripts/tmux/welcome/.result"
declare run="${1:-0}" original_session="$2" SCRIPT="$WELCOME_PATH/welcome.sh"

cd "$WELCOME_PATH" || exit

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
	quote="$(fortune -s 2>/dev/null)"
	[ -z "$quote" ] && quote="Evil is Evil."
	# for some reason fortune just ignores the -s option, so i try a few times
	# to get a short cookie before giving up
	counter=0
	while [ "${#quote}" -gt 80 ] && [ "$counter" -lt 10 ]; do
		quote="$(fortune -s 2>/dev/null)"
		counter=$((counter + 1))
	done

	tmux list-sessions -f "#{!=:#{session_name},$WELCOME_SESSION}" -F "#{session_name} #{session_windows} #{session_id}" | \
		"$WELCOME_PATH/welcome" -width "$w" -height "$h" -result "$RESPATH" -quote "$quote" || exit 1

	id="$(cat "$RESPATH")"
	if [ -z "$id" ]; then
		tmux switch-client -t "$original_session"
		tmux set -g status
		exit
	fi

	case "$id" in
		"@detach")
			tmux detach
			exit
			;;

		"@create"*)
			name=$(awk '{$1=""; print $0}' <<< "$id" | xargs)
			dup=$(tmux ls | awk "\$1 == \"${name}:\"")
			if [ -z "$dup" ]; then
				tmux new-session -d -s "$name" -c "$HOME"
			fi
			tmux switch-client -t "$name"
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

		"@kill-server")
			tmux kill-server
			;;

		"@reboot")
			sudo shutdown -r now
			;;

		"@shutdown")
			sudo shutdown now
			;;

		*)
			tmux switch-client -t "$id"
			;;
	esac
}

if [ "$run" -eq 1 ]; then
	main "$original_session"
	tmux set -g status
	exit
fi

if [ "$(tmux display -p '#{session_name}')" = "$WELCOME_SESSION" ]; then
	exit
fi

tmux kill-session -t "$WELCOME_SESSION"

tmux set -g status
tmux new-session -d -s "$WELCOME_SESSION" "$SCRIPT 1 \"$(tmux display -p '#{session_name}')\""
tmux switch-client -t "$WELCOME_SESSION"
