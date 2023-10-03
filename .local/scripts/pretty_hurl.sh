#! /usr/bin/env bash

file="$1"
query="${2:-.}"

output=$(hurl --color -iL "$file")
headers=$(awk '{ if (NF == 0) over = 1 } { if (over == 0) { print $0 } }' <<< "$output")
body=$(awk '{ if (NF == 0) over = 1 } { if (over > 0) { print $0 } }' <<< "$output")

printf "%s\n\n" "$headers"

[ -n "$query" ] && printf "Query: %s\n\n" "$query"

jq "$query" <<< "$body" 2>/dev/null || printf "Query failed.\nRaw output:\n%s\n" "$body"
