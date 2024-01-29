#! /usr/bin/env bash

current_session=$(tmux display -p "#{session_name}")
if [ "$current_session" = "alice" ]; then
	tmux switch-client -l
	exit
fi

if ! tmux has-session -t alice; then
	tmux new-session -d -s alice -n alice
fi

tmux switch-client -t alice

current_cmd=$(tmux display -p "#{pane_current_command}")
if [ "$current_cmd" = "fish" ]; then
	tmux send-keys -t . ask Enter
fi

true
