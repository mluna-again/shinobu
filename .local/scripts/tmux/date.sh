#! /bin/sh

format="+ %I:%M %p • %a %d"
if [ -n "$(tmux display -p '#{@zen_mode}')" ]; then
	format="+ %I:%M %p"
fi

width="$1"
icon_color="$2"

[ "$width" -lt 100 ] && format="+ %I:%M %p"

time=$(LC_TIME=en_US.UTF-8 date "$format" | tr '[:upper:]' '[:lower:]')

printf "#[fg=terminal,bg=terminal]%s #[fg=black,bg=%s] 󰥔 #[fg=white,bg=terminal]" "$time" "$icon_color"
