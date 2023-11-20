#! /usr/bin/env bash

bg="$1"
width="$2"
hostname=$(hostname)

[ "$width" -le 100 ] && exit

[ -n "$SSH_CLIENT" ] && printf " #[fg=black,bg=%s] 󰒍 #[fg=terminal,bg=terminal] %s" "$bg" "$hostname"

true
