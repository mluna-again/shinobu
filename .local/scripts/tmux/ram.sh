#! /usr/bin/env bash

if [ -z "$(tmux display -p '#{@zen_mode}')" ]; then
	exit
fi

background="$1"
width="$2"

[ "$width" -lt 100 ] && exit

if uname | grep -i darwin &>/dev/null; then
	output=$(top -l 1 | grep -E "^PhysMem"  | awk '{print $2}' | numfmt --to=iec --from=si)
else
	output=$(free -b | awk 'NR == 2 {print $3}' | numfmt --to=iec --from=si)
fi

printf "#[fg=black,bg=%s] 󰍛 #[bg=terminal,fg=terminal] %s" "$background" "$output"
