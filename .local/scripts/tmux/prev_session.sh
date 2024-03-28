#! /usr/bin/env bash

current=$(tmux display -p "#{session_name}")

prev=$(tmux list-sessions -F "#{session_name}" |
	awk "{ if (\$0 == \"$current\") {print prev; exit;} ; prev=\$0; }")

if [ -z "$prev" ]; then
	tmux switch-client -t "$(tmux list-sessions -F '#{session_name}' | tail -1)"
	exit
fi

tmux switch-client -t "$prev"
