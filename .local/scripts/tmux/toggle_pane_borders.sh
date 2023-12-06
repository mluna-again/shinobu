#! /usr/bin/env bash

ignored_windows='["cmd","pgsql","dashboard","code","api","koi"]'
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
