#! /usr/bin/env bash

w="$1"
h="$2"

path="$HOME/.local/scripts/shift"

[ ! -x "$path/shift" ] && go build -C "$path" -o "$path/shift"

get_sessions() {
	tmux list-sessions |\
		awk '{print $1}' |\
		awk '{ gsub(/:/, "", $1); print $1 }'
}

get_sessions | "$path/shift" "$w" "$h" || { echo "Something went wrong..."; exit 1; }

[ ! -e .__SHIFT__ ] && exit

mode="$(awk '{print $1}' .__SHIFT__)"
session_name="$(awk '{print $2}' .__SHIFT__)"
session_path="$(awk '{print $3}' .__SHIFT__)"

rm .__SHIFT__

case "$mode" in
	create)
		[ -n "$session_path" ] && tmux new-session -d -s "$session_name" -c "$(eval echo "$session_path")" && tmux switch-client -t "$session_name" && exit

		tmux new-session -d -s "$session_name" -c "$HOME" && tmux switch-client -t "$session_name"
		;;

	switch)
		tmux switch-client -t "$session_name"
		;;

	rename)
		tmux rename-session "$session_name"
		;;

	*)
		exit
		;;
esac
