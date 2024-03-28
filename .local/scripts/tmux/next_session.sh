#! /usr/bin/env bash

current=$(tmux display -p "#{session_name}")

next=$(tmux list-sessions -F "#{session_name}" |
	awk "{ if (prev == \"$current\") {print \$0; exit;} ; prev=\$0; }")

if [ -z "$next" ]; then
	tmux switch-client -t "$(tmux list-sessions -F '#{session_name}' | head -1)"
	exit
fi

tmux switch-client -t "$next"
