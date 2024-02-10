#! /usr/bin/env bash

width="$1"
bg="$2"
zoomed="$(tmux display-message -p '#{window_zoomed_flag}')"

if [ "$zoomed" -ne 1 ]; then
	exit
fi

message="#[fg=black,bg=$bg]  #[fg=terminal,bg=terminal] ZOOMED"

if [ "$width" -lt 100 ]; then
	message=""
fi

if [ -n "$(tmux display -p '#{@zen_mode}')" ]; then
	message=""
fi

printf "%s " "$message"
