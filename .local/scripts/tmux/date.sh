#! /bin/sh

width="$1"
icon_color="$2"

[ "$width" -lt 100 ] && exit

time=$(date "+ %I:%M %p • %a %d")

printf "#[fg=terminal,bg=terminal]%s #[fg=black,bg=%s] 󰥔 #[fg=white,bg=terminal]" "$time" "$icon_color"
