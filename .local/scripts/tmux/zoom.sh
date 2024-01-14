#! /usr/bin/env bash

zoomed=$(tmux display-message -p "#{window_zoomed_flag}")
if [ "$zoomed" -eq 1 ]; then
	"$HOME/.local/scripts/tmux/toggle_pane_borders.sh"
else
	tmux set -g pane-border-status off
fi

tmux resize-pane -t . -Z
