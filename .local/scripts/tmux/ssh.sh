#! /usr/bin/env bash

bg="$1"
width="$2"
force="$3"
hostname=$(hostname)

[ "$width" -le 100 ] && exit

{ [ -n "$SSH_CLIENT" ] || [ "$force" = true ] ; } && printf " #[fg=black,bg=%s] 󰒍 #[fg=terminal,bg=terminal] %s" "$bg" "$hostname"

true
