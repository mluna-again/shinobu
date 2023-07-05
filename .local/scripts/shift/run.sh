#! /usr/bin/env bash

w="$1"
h="$2"
mode="${3:-sessions}"

path="$HOME/.local/scripts/shift"

[ ! -x "$path/shift" ] && go build -C "$path" -o "$path/shift"

get_sessions() {
	tmux list-sessions |\
		awk '{print $1}' |\
		awk '{ gsub(/:/, "", $1); print $1 }'
}

get_windows() {
	tmux list-windows |\
		awk '{print $2}' |\
		awk '{ gsub(/[\*#-]/, "", $1); print $1 }'
}

handle_sessions() {
	[ ! -e .__SHIFT__ ] && exit

	mode="$(awk '{print $1}' .__SHIFT__)"
	params="$(awk '{for(i=2; i<=NF;i++) printf "%s ", $i}' .__SHIFT__)"

	rm .__SHIFT__

	case "$mode" in
		create)
			session_name="$(awk '{print $1}' <<< "$params")"
			session_path="$(awk '{print $2}' <<< "$params")"

			[ -n "$session_path" ] && tmux new-session -d -s "$session_name" -c "$(eval echo "$session_path")" && tmux switch-client -t "$session_name" && exit

			tmux new-session -d -s "$session_name" -c "$HOME" && tmux switch-client -t "$session_name"
			;;

		switch)
			session_name="$(awk '{print $1}' <<< "$params")"
			tmux switch-client -t "$session_name"
			;;

		rename)
			session_name="$(awk '{print $1}' <<< "$params")"
			tmux rename-session "$session_name"
			;;

		*)
			exit
			;;
	esac
}

handle_windows() {
	[ ! -e .__SHIFT__ ] && exit

	window_name="$(awk '{print $2}' .__SHIFT__)"
	rm .__SHIFT__

	tmux select-window -t "$window_name"
}

case "$mode" in
	sessions)
		get_sessions | "$path/shift" "$w" "$h" || { echo "Something went wrong..."; exit 1; }
		handle_sessions
		;;

	windows)
		get_windows | "$path/shift" "$w" "$h" "$mode" || { echo "Something went wrong..."; exit 1; }
		handle_windows
		;;

	*)
		get_sessions | "$path/shift" "$w" "$h" || { echo "Something went wrong..."; exit 1; }
		handle_sessions
		;;
esac
