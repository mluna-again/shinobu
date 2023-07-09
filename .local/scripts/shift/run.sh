#! /usr/bin/env bash

w="$1"
h="$2"
mode="${3:-sessions}"

path="$HOME/.local/scripts/shift"

[ ! -x "$path/shift" ] && go build -C "$path" -o "$path/shift"

_remove_trailing_slash() {
	awk '{print $1}' <<< "$1" |\
		awk '{sub(/\/$/, "", $1); print $1}'
}

get_sessions() {
	sessions="$(tmux list-sessions)"

	current="$(grep -i attached <<< "$sessions")"
	without_current="$(grep -iv attached <<< "$sessions")"

	# clean up lines
	current="$(awk '{ print $1 }' <<< "$current" |\
						 awk '{ gsub(/:/, "", $1); print $1 }')"
	without_current="$(awk '{ print $1 }' <<< "$without_current" |\
						 awk '{ gsub(/:/, "", $1); print $1 }')"

	# print current session always first
	echo "$current"
	echo "$without_current"
}

get_windows() {
	windows="$(tmux list-windows)"

	current="$(grep -i active <<< "$windows")"
	without_current="$(grep -iv active <<< "$windows")"

	current="$(awk '{ print $2 }' <<< "$current" |\
		         awk '{ gsub(/[\*#-]/, "", $1); print $1 }')"
	without_current="$(awk '{ print $2 }' <<< "$without_current" |\
		         awk '{ gsub(/[\*#-]/, "", $1); print $1 }')"

	echo "$current"
	echo "$without_current"
}

handle_sessions() {
	[ ! -e .__SHIFT__ ] && exit

	mode="$(awk '{print $1}' .__SHIFT__)"
	params="$(awk '{for(i=2; i<=NF;i++) printf "%s ", $i}' .__SHIFT__)"

	rm .__SHIFT__

	case "$mode" in
		create)
			session_name="$(_remove_trailing_slash "$params")"
			session_path="$(awk '{print $2}' <<< "$params")"
			session_path="$(_remove_trailing_slash "$session_path")"

			[ -n "$session_path" ] && tmux new-session -d -s "$session_name" -c "$(eval echo "$session_path")" && tmux switch-client -t "$session_name" && exit

			tmux new-session -d -s "$session_name" -c "$HOME" && tmux switch-client -t "$session_name"
			;;

		switch)
			session_name="$(_remove_trailing_slash "$params")"
			tmux switch-client -t "$session_name"
			;;

		rename)
			session_name="$(_remove_trailing_slash "$params")"
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
