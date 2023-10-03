#! /usr/bin/env bash

output=$(hurl --color -iL "$@")
headers=$(awk '{ if (NF == 0) over = 1 } { if (over == 0) { print $0 } }' <<< "$output")
body=$(awk '{ if (NF == 0) over = 1 } { if (over > 0) { print $0 } }' <<< "$output")

printf "%s\n\n" "$headers"
jq '.' <<< "$body" 2>/dev/null || printf "%s\n" "$body"
