#! /usr/bin/env bash

panes_count=$(tmux list-panes | wc -l)

if [ "$panes_count" -eq 1 ]; then
	exit
fi

if [ "$panes_count" -ge 4 ]; then
	tmux select-layout tiled
	exit
fi

tmux select-layout even-horizontal
