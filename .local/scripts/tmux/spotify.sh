#! /usr/bin/env bash

declare width="${1:-180}" BOP_PORT=8888

if [ "$width" -le 100 ]; then
  exit
fi

output=$(curl -fsSL "http://localhost:$BOP_PORT/status")
[ -z "$output" ] && exit

song=$(jq -r '.display_name' <<< "$output")
[ -z "$song" ] && exit
ssong=$(cut -c -15 <<< "$song")
if [ "$ssong" != "$song" ]; then
  song="${ssong}..."
fi

artist=$(jq -r '.artist' <<< "$output")
[ -z "$artist" ] && exit
sartist=$(cut -c -15 <<< "$artist")
if [ "$sartist" != "$artist" ]; then
  artist="${sartist}..."
fi

echo "#[fg=default,bg=default]$song by $artist #[bg=green,fg=black]  "
