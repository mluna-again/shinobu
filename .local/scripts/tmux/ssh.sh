#! /usr/bin/env bash

if [ -n "$(tmux display -p '#{@zen_mode}')" ]; then
	exit
fi

bg="$1"
width="$2"
force="$3"
hostname=$(hostname)

[ "$width" -le 100 ] && exit

{ [ -n "$SSH_CLIENT" ] || [ "$force" = true ] ; } && printf "#[fg=black,bg=%s] 󰒍 #[fg=terminal,bg=terminal] %s " "$bg" "$hostname"

true
