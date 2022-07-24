#!/bin/sh

cache_file="$HOME/.cache/weather"
request_cmd="curl -s 'wttr.in/London?format=%c%t\n' | tee -a $cache_file"

[ -f "$cache_file" ] || (date +"%H %M" >> "$cache_file" && eval "$request_cmd" &>/dev/null)

cache=$(/bin/cat "$cache_file" | head -1)

hour=$(echo "$cache" | awk '{print $1}')
minute=$(echo "$cache" | awk '{print $2}')

curr_hour=$(date +"%H")
curr_min=$(date +"%M")

if [ "$curr_hour" == "$hour" ] && (( $curr_min <= $minute + 5 )); then
  # less than 5 mins since last update
  /bin/cat "$cache_file" | tail -n +2
else
  date +"%H %M" > "$cache_file"
  eval "$request_cmd"
fi
