#! /usr/bin/env bash

debug() {
	printf "\033[0;33m"
	printf "%s" "$1"
	printf "\033[0m"
	printf "\n"
}

error() {
	printf "\033[0;31m"
	printf "%s" "$1"
	printf "\033[0m"
	printf "\n"
}

file="$1"
query="${2:-.}"

output=$(hurl --color -iL "$file")
headers=$(awk '{ if (NF == 0) over = 1 } { if (over == 0) { print $0 } }' <<< "$output")
body=$(awk '{ if (NF == 0) over = 1 } { if (over > 0) { print $0 } }' <<< "$output")

printf "%s\n\n" "$headers"

debug "Running: jq '$query'"

jq "$query" <<< "$body" 2>/dev/null || {
	error "Query failed."
	debug "Raw output:"
	printf "%s\n" "$body"
	exit 1
}
