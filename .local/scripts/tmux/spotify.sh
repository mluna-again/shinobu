#! /usr/bin/env bash

declare width="${1:-180}" BOP_PORT=8888

if [ "$width" -le 100 ]; then
  exit
fi

output=$(curl -fsSL "http://localhost:$BOP_PORT/status")
[ -z "$output" ] && exit

title=$(jq -r '"\(.display_name) by \(.artist)"' <<< "$output")
[ -z "$title" ] && exit

short=$(cut -c -30 <<< "$title")

if [ "$short" != "$title" ]; then
  title="$short..."
fi

echo "#[fg=default,bg=default]$title #[bg=green,fg=black]  "
