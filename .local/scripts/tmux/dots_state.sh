#! /usr/bin/env bash

bg="$1"
width="$2"

[ "$width" -lt 100 ] && exit

FIVE_MINUTES_IN_SECONDS=$(( 60 * 5 ))

CACHE_FILE="$HOME/.cache/.dots_state_last_check"
if [ ! -e "$CACHE_FILE" ]; then
	date +"%s" > "$CACHE_FILE"
fi

last_time_in_seconds=$(awk 'NR == 1' "$CACHE_FILE")
now_in_seconds=$(date +"%s")
diff=$(( now_in_seconds - last_time_in_seconds ))

if [ "$diff" -ge "$FIVE_MINUTES_IN_SECONDS" ]; then
	yadm fetch origin
	count=$(yadm rev-list --left-right --count master...origin/master | awk '{print $2}')

	if [ "$count" -gt 0 ]; then
		text="#[bg=terminal,fg=yellow]$count #[bg=$bg,fg=black]  "
	else
		text=""
	fi

	date +"%s" > "$CACHE_FILE"
	printf "%s\n" "$text" >> "$CACHE_FILE"
	printf "%s" "$text"
else
	awk 'NR == 2' "$CACHE_FILE"
fi
