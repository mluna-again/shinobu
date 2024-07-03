#! /usr/bin/env bash

installed() {
	if ! command -v "$1" &>/dev/null; then
		echo "$2" >&2
		exit 1
	fi
}

installed hurl "Missing dependency: hurl"
installed jnv "Missing dependency: jnv"

isdarwin() {
	uname | grep -i darwin
}

date="date"
if isdarwin; then
	date=gdate
fi

if ! command -v "$date" &>/dev/null; then
	echo "Please install gnu date" >&2
	exit 1
fi

DATE_FMT="+%Y-%m-%dT%H:%M:%S%z"
NOW=$("$date" -u "$DATE_FMT")

HURL_KOI_NOW=$("$date" -u -d "$NOW" "$DATE_FMT") || exit
HURL_KOI_YESTERDAY=$("$date" -u -d "$NOW -1 days" "$DATE_FMT") || exit
HURL_KOI_TOMORROW=$("$date" -u -d "$NOW +1 days" "$DATE_FMT") || exit
HURL_KOI_TODAY=$("$date" -u -d "$NOW" "$DATE_FMT") || exit
HURL_KOI_UUID=$(uuidgen) || exit
HURL_KOI_RANDOM=$RANDOM
HURL_KOI_LOREM="Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
export HURL_KOI_YESTERDAY
export HURL_KOI_NOW
export HURL_KOI_TOMORROW
export HURL_KOI_TODAY
export HURL_KOI_UUID
export HURL_KOI_RANDOM
export HURL_KOI_LOREM

file="$1"
if [ -z "$file" ]; then
	echo "Missing file." >&2
	exit 1
fi

output=$(hurl --color --error-format=long "$file") || exit
jnv <<< "$output"
