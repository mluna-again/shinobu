#! /usr/bin/env bash

w="$1"
h="$2"
mode="${3:-sessions}"

path="$HOME/.local/scripts/shift"

[ -e .__SHIFT__ ] && rm .__SHIFT__

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
	windows="$(tmux list-windows -F '#W')"

	current="$(grep -i active <<< "$windows")"
	without_current="$(grep -iv active <<< "$windows")"

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

			[ -z "$session_name" ] && return

			[ -n "$session_path" ] && tmux new-session -d -s "$session_name" -c "$(eval echo "$session_path")" && tmux switch-client -t "$session_name" && exit

			tmux new-session -d -s "$session_name" -c "$HOME" && tmux switch-client -t "$session_name"
			;;

		switch)
			session_name="$(_remove_trailing_slash "$params")"
			[ -z "$session_name" ] && return

			tmux switch-client -t "$session_name"
			;;

		rename)
			session_name="$(_remove_trailing_slash "$params")"
			[ -z "$session_name" ] && return

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

get_all() {
	curr=$(tmux display -p "#{session_name}")
	output=$(tmux list-windows -a -F '#{session_name}: #{window_name}')

	# order windows from current session first
	current_session_windows=$(grep "$curr" <<< "$output")
	remaining_windows=$(grep -v "$curr" <<< "$output" | sort)
	printf "%s\n%s" "$current_session_windows" "$remaining_windows"
}

handle_all() {
	[ ! -e .__SHIFT__ ] && exit

	output=$(xargs sh -c 'printf "%s %s" $1 $2' < .__SHIFT__)
	session=$(awk -F':' '{ print $1 }' <<< "$output")
	session=$(awk '{ print $1 }' <<< "$session")
	window=$(awk -F':' '{ print $2 }' <<< "$output")
	window=$(awk '{ print $1 }' <<< "$window")

	[ -z "$session" ] && exit
	[ -z "$window" ] && exit
	tmux switch-client -t "$session"
	tmux select-window -t "$window"
}

case "$mode" in
	sessions)
		get_sessions | "$path/shift" -width "$w" -height "$h" || { echo "Something went wrong..."; exit 1; }
		handle_sessions
		;;

	windows)
		get_windows | "$path/shift" -icon "  " -width "$w" -height "$h" -title " Switch window " "$mode" || { echo "Something went wrong..."; exit 1; }
		handle_windows
		;;

	all)
		get_all | "$path/shift" -icon "  " -width "$w" -height "$h" -title " Which way do I go? " "$mode" || { echo "Something went wrong..."; exit 1; }
		handle_all
		;;

	*)
		get_sessions | "$path/shift" -width "$w" -height "$h" || { echo "Something went wrong..."; exit 1; }
		handle_sessions
		;;
esac
