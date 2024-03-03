#! /usr/bin/env bash

declare SHIFT_PATH="$HOME/.local/scripts/shift/shift" OUTFILE="$HOME/.cache/.cornucopia"

: > "$OUTFILE"

: # bash 5+ required
# shellcheck disable=SC2120
die() {
	[ -n "$*" ] && tostderr "$*"
	exit 1
}
tostderr() {
	tput setaf 1 && printf "%s@%s: %s\n" "$0" "${BASH_LINENO[-2]}" "$*" >&2
	tput sgr0
}
istmux() { [ -n "$TMUX" ]; }
talert() { tmux display -d 0 "#[bg=#{@color_info},fill=#{@color_info},fg=black] 󰭺 Message: $*"; }
terror() { tmux display -d 0 "#[bg=#{@color_error},fill=#{@color_error},fg=black]  Message: $*"; }
tsuccess() { tmux display -d 0 "#[bg=#{@color_success},fill=#{@color_success},fg=black]  Message: $*"; }

read_result() {
	tail -1 "$OUTFILE"
}

istmux || die this script only works inside tmux

if [ ! -x "$SHIFT_PATH" ]; then
	terror "shift not installedk"
	exit
fi

fetch_foods() {
	local food="$1"

	req_body='{"includeDataTypes":{"Survey (FNDDS)":false,"Foundation":true,"Branded":false,"SR Legacy":false,"Experimental":false},"referenceFoodsCheckBox":true,"requireAllWords":true,"sortCriteria":{"sortColumn":"description","sortDirection":"asc"},"pageNumber":1,"exactBrandOwner":null,"currentPage":1,"generalSearchInput":"<%food%>"}'
	req_body="$(sed "s/<%food%>/$food/" <<<"$req_body")"

	curl 'https://fdc.nal.usda.gov/portal-data/external/search' \
		-s \
		-X POST \
		-H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:123.0) Gecko/20100101 Firefox/123.0' \
		-H 'Accept: application/json, text/plain, */*' \
		-H 'Accept-Language: en-US,en;q=0.5' \
		-H 'Accept-Encoding: gzip, deflate, br' \
		-H 'Content-Type: application/json' \
		-H 'Origin: https://fdc.nal.usda.gov' \
		-H 'Connection: keep-alive' \
		-H 'Referer: https://fdc.nal.usda.gov/fdc-app.html' \
		-H 'Sec-Fetch-Dest: empty' \
		-H 'Sec-Fetch-Mode: cors' \
		-H 'Sec-Fetch-Site: same-origin' \
		-H 'Pragma: no-cache' \
		-H 'Cache-Control: no-cache' \
		--data-raw "$req_body"
}

tmux display-popup -w 65 -h 11 -y 15 -E "$(cat - <<EOF
	"$SHIFT_PATH" -mode create \
		-title " Search by name " \
		-icon " 󰉜 " \
		-input "\n" \
		-width 65 \
		-height 9 \
		-output "$OUTFILE"
EOF
)"

query="$(read_result)"
[ -z "$query" ] && exit

results="$(fetch_foods "$query")"

options="$(echo "$results" | jq -r '.foods[].description' | awk '{ printf "%d. %s\n", NR, $0 }')"
if [ -z "$options" ]; then
	terror "No matches found."
	exit
fi

tmux display-popup -w 65 -h 11 -y 15 -E "$(cat - <<EOF
	echo "$options" |
		"$SHIFT_PATH" \
		-title " Search by name " \
		-icon " 󰉜 " \
		-width 65 \
		-height 9 \
		-output "$OUTFILE"
EOF
)"

food_index="$(read_result | awk '{print $1}' | sed 's/[^0-9]//g')"
[ -z "$food_index" ] && exit
food_id="$(jq ".foods[$((food_index - 1))].fdcId" <<<"$results")"

talert "$food_id"
