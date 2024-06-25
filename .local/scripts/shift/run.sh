#! /usr/bin/env bash

if [ "$(tmux display -p '#{session_name}')" = __WELCOME__ ]; then
	exit
fi

w="$1"
h="$2"
mode="${3:-sessions}"

error() {
	tmux display-message -d 0 "#[bg=red,fill=red,fg=black]  Error: $1"
}

_filter_running_programs() {
	grep -v tmux | grep -v fish
}

_remove_trailing_slash() {
	awk '{print $1}' <<< "$1" |\
		awk '{sub(/\/$/, "", $1); print $1}'
}

get_sessions() {
	sessions="$(tmux list-sessions -F '#{session_name}')"

	while read -r line; do
		running_programs="$(tmux list-panes -s -t "$line" -F "#{pane_current_command}" | _filter_running_programs | wc -l)"
		printf "%s (running %d programs)\n" "$line" "$running_programs"
	done <<< "$sessions"
}

get_windows() {
	windows="$(tmux list-windows -F '#W')"

	current="$(grep -i active <<< "$windows")"
	without_current="$(grep -iv active <<< "$windows")"

	echo "$current"
	echo "$without_current"
}

handle_sessions() {
	local input="$1"
	mode="$(echo "$input" | awk '{print $1}')"
	params="$(echo "$input" | awk '{for(i=2; i<=NF;i++) printf "%s ", $i}')"

	case "$mode" in
		create)
			session_name="$(_remove_trailing_slash "$params")"
			session_path="$(awk '{print $2}' <<< "$params")"
			session_path="$(_remove_trailing_slash "$session_path")"

			[ -z "$session_name" ] && return

			current=$(tmux display -p "#{session_name}")
			[ "$session_name" = "$current" ] && {
				tmux display-message -d 0 "#[bg=red,fill=red,fg=black]  Message: Duplicate session" ; exit
			}

			session_path="${session_path/#\~/$HOME}"
			[ -d "$session_path" ] && tmux new-session -d -s "$session_name" -c "$session_path" && tmux switch-client -t "$session_name" && exit

			tmux new-session -d -s "$session_name" -c "$HOME" && tmux switch-client -t "$session_name"
			;;

		switch)
			session_name="$(_remove_trailing_slash "$params")"
			[ -z "$session_name" ] && return

			tmux switch-client -t "$session_name" || error "Could not switch to $session_name. Maybe there are multiple with the same name?"
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
	local input="$1"
	window_name="$(echo "$input" | awk '{print $2}')"

	tmux select-window -t "$window_name" || error "Could not switch to $window_name. Maybe there are multiple with the same name?"
}

get_all() {
	curr_session=$(tmux display -p "#{session_name}")
	curr_window=$(tmux display -p "#{window_name}")
	output=$(tmux list-windows -a -F '#{session_name}: #{window_name}')

	# order windows from current session first
	current_session_windows=$(grep "$curr_session" <<< "$output")
	current_window_active=$(grep "$curr_window" <<< "$current_session_windows")
	current_window_remaining=$(grep -v "$curr_window" <<< "$current_session_windows" | sort)


	remaining_windows=$(grep -v "$curr_session" <<< "$output" | sort)

	printf "%s\n%s\n%s" "$current_window_active" "$current_window_remaining" "$remaining_windows"
}

handle_all() {
	local input="$1"

	output=$(xargs sh -c 'printf "%s %s %s" $1 $2 $0 $3' <<< "$input")
	session=$(awk -F':' '{ print $1 }' <<< "$output")
	session=$(awk '{ print $1 }' <<< "$session")
	window=$(awk -F':' '{ print $2 }' <<< "$output")
	window=$(awk '{ print $1 }' <<< "$window")
	mode=$(awk '{ print $3 }' <<< "$output")
	[ -z "$mode" ] && mode=$(awk '{ print $2 }' <<< "$output")

	case "$mode" in
		create)
			session_path="$(awk '{print $2}' <<< "$output")"

			current=$(tmux display -p "#{session_name}")
			[ "$session" = "$current" ] && {
				tmux display-message -d 0 "#[bg=red,fill=red,fg=black]  Message: Duplicate session" ; exit
			}

			session_path="${session_path/#\~/$HOME}"
			[ -d "$session_path" ] && tmux new-session -d -s "$session" -c "$session_path" && tmux switch-client -t "$session" && exit

			tmux new-session -d -s "$session" -c "$HOME" && tmux switch-client -t "$session"
			;;

		rename)
			[ -z "$session" ] && return

			tmux rename-session "$session"
			;;

		*)
			[ -z "$session" ] && exit
			[ -z "$window" ] && exit
			tmux switch-client -t "$session" || {
				error "Could not switch to $session. Maybe there are multiple with the same name?"
				exit
			}
			tmux select-window -t "$window" || {
				error "Could not switch to $window. Maybe there are multiple with the same name?"
				exit
			}
			;;
	esac
}

case "$mode" in
	sessions)
		response=$(get_sessions | mshift -width "$w" -height "$h") || { echo "Something went wrong..."; exit 1; }
		handle_sessions "$response"
		;;

	windows)
		response=$(get_windows | mshift -icon "  " -width "$w" -height "$h" -title " Switch window " "$mode") || { echo "Something went wrong..."; exit 1; }
		handle_windows "$response"
		;;

	all)
		response=$(get_all | mshift -icon "  " -width "$w" -height "$h" -title " Which way do I go? " "sessions") || { echo "Something went wrong..."; exit 1; }
		handle_all "$response"
		;;

	*)
		response=$(get_sessions | mshift -width "$w" -height "$h") || { echo "Something went wrong..."; exit 1; }
		handle_sessions "$response"
		;;
esac
