#! /usr/bin/env bash

w="$1"
h="$2"
mode="${3:-sessions}"

error() {
	tmux display-message -d 0 "#[bg=red,fill=red,fg=black]  Error: $1"
}

path="$HOME/.local/scripts/shift"

OUTPUT_PATH="$path/.__SHIFT__"

[ -e "$OUTPUT_PATH" ] && rm "$OUTPUT_PATH"

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
	mode="$(awk '{print $1}' "$OUTPUT_PATH")"
	params="$(awk '{for(i=2; i<=NF;i++) printf "%s ", $i}' "$OUTPUT_PATH")"

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
	window_name="$(awk '{print $2}' "$OUTPUT_PATH")"

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
	output=$(xargs sh -c 'printf "%s %s %s" $1 $2 $0 $3' < "$OUTPUT_PATH")
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
			[ -n "$session_path" ] && tmux new-session -d -s "$session" -c "$(eval echo "$session_path")" && tmux switch-client -t "$session" && exit

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
		get_sessions | "$path/shift" -width "$w" -height "$h" || { echo "Something went wrong..."; exit 1; }
		[ ! -e "$OUTPUT_PATH" ] && exit
		handle_sessions
		;;

	windows)
		get_windows | "$path/shift" -icon "  " -width "$w" -height "$h" -title " Switch window " "$mode" || { echo "Something went wrong..."; exit 1; }
		[ ! -e "$OUTPUT_PATH" ] && exit
		handle_windows
		;;

	all)
		get_all | "$path/shift" -icon "  " -width "$w" -height "$h" -title " Which way do I go? " "sessions" || { echo "Something went wrong..."; exit 1; }
		[ ! -e "$OUTPUT_PATH" ] && exit
		handle_all
		;;

	*)
		get_sessions | "$path/shift" -width "$w" -height "$h" || { echo "Something went wrong..."; exit 1; }
		[ ! -e "$OUTPUT_PATH" ] && exit
		handle_sessions
		;;
esac
