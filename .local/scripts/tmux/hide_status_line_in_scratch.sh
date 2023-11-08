#! /usr/bin/env bash

session=$(tmux display-message -p '#{session_name}')

if [ "$session" = scratch ]; then
	tmux set status off
fi
