#! /usr/bin/env bash

w="$1"
h="$2"

"$HOME"/.local/scripts/shift/shift "$w" "$h" || { echo "Something went wrong..."; exit 1; }

[ ! -e .__SHIFT__ ] && exit

mode="$(awk '{print $1}' .__SHIFT__)"
session_name="$(awk '{print $2}' .__SHIFT__)"
session_path="$(awk '{print $3}' .__SHIFT__)"

rm .__SHIFT__

case "$mode" in
	create)
		tmux new-session -d -s "$session_name" -c "$session_path" && tmux switch-client -t "$session_name"
		;;

	switch)
		tmux switch-client -t "$session_name"
		;;

	*)
		exit
		;;
esac
