#! /usr/bin/env bash

bg="$1"
width="$2"

ORIGIN_OF_SPACE_AND_TIME=$(date -d "1970-01-01 00:00 UTC" +"%s")

CACHE_FILE="$HOME/.cache/.pomodoro"
[ -e "$CACHE_FILE" ] || touch "$CACHE_FILE"

remaining_time=$(awk 'NR == 1' "$CACHE_FILE" | date +"%M:%S")
[ -z "$remaining_time" ] && exit

remaining_time=$(( remaining_time - 1 ))
message="#[bg=$bg,fg=yellow]  #[bg=terminal,fg=terminal] $remaining_time"

echo "$ORIGIN_OF_SPACE_AND_TIME"
