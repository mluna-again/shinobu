#! /usr/bin/env bash

if [ "$(tmux display -p '#{session_name}')" = emacs ]; then
	tmux switch-client -l
	exit
fi

tmux new-session -d -s emacs -c "$HOME" emacs -nw &>/dev/null || true
tmux switch-client -t emacs \; rename-window -t . editor || true
