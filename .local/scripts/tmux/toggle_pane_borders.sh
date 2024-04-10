#! /usr/bin/env bash

CACHE="$HOME/.cache/toggle_borders.sh"
[ -f "$CACHE" ] || touch "$CACHE"

zoomed="$(tmux display-message -p '#{window_zoomed_flag}')"
if [ "$zoomed" -eq 1 ]; then
	tmux set -g pane-border-status off
	exit
fi

ignored_windows="$(cat "$CACHE")"
current_window=$(
	tmux list-windows -F "#{window_name} #{window_active}" | \
		awk '$2 == 1' | \
		awk '{print $1}'
)

arg=$(printf '. as $f | "%s" | IN($f[])' "$current_window")
res=$(jq "$arg" <<< "$ignored_windows")
if [ "$res" = "true" ]; then
	tmux set -g pane-border-status off
	exit
fi

count=$(tmux list-panes | wc -l)

[ "$count" -gt 1 ] && tmux set -g pane-border-status top
[ "$count" -lt 2 ] && tmux set -g pane-border-status off

true
