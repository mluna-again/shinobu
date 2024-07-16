#! /usr/bin/env bash

if [ "$(tmux display -p '#{session_name}')" = scratch ]; then
	tmux switch-client -l
	exit
fi

tmux switch-client -t scratch
