#! /bin/sh

icon_color="$2"

time=$(date "+ %I:%M %p • %a %d")

printf "#[fg=white,bg=terminal]%s #[fg=black,bg=%s] 󰥔 #[fg=white,bg=terminal]" "$time" "$icon_color"
