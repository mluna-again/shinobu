#! /usr/bin/env bash

w="$1"
h="$2"

"$HOME"/.local/scripts/shift/shift "$w" "$h" || { echo "Something went wrong..."; exit 1; }

[ ! -e .__SHIFT__ ] && exit

selection="$(cat .__SHIFT__)"
rm .__SHIFT__
tmux switch-client -t "$selection"
