#! /usr/bin/env bash

declare SHIFT_PATH="$HOME/.local/scripts/shift/shift" \
	OUTFILE="$HOME/.cache/.cornucopia" \
	DATABASE="$HOME/.cache/.cornucopia.json"

db_template() {
	local timestamp="$1"
	[ -z "$timestamp" ] && die No timestamp provided

	cat - <<-EOF
		{
			"last_updated_at": "$timestamp",
			"breakfast": [],
			"dinner": [],
			"lunch": [],
			"extra": []
		}
	EOF
}

: >"$OUTFILE"

: # bash 5+ required
# shellcheck disable=SC2120
die() {
	[ -n "$*" ] && terror "$*"
	exit
}
assert_installed() { command -v "$1" &>/dev/null || die "$1 is not installed."; }
istmux() { [ -n "$TMUX" ]; }
talert() { tmux display -d 0 "#[bg=#{@color_info},fill=#{@color_info},fg=black] 󰭺 Message: $*"; }
terror() { tmux display -d 0 "#[bg=#{@color_error},fill=#{@color_error},fg=black]  Message: $*"; }
tsuccess() { tmux display -d 0 "#[bg=#{@color_success},fill=#{@color_success},fg=black]  Message: $*"; }

read_result() {
	tail -1 "$OUTFILE"
}

istmux || die this script only works inside tmux
assert_installed jq

if [ ! -x "$SHIFT_PATH" ]; then
	terror "shift not installed"
	exit
fi

empty_db_if_older_than_today() {
	local day last_date today timestamp

	timestamp="$(date +'%d/%m/%Y')"

	if [ ! -f "$DATABASE" ]; then
		db_template "$timestamp" >"$DATABASE"
		return
	fi

	today="$(date +'%d')"
	last_date="$(jq -r '.last_updated_at' "$DATABASE")"
	day="$(awk -F"/" '{print $1}' <<<"$last_date")"
	if [ -z "$day" ] || ((today > day)); then
		db_template "$timestamp" >"$DATABASE"
	fi
}

empty_db_if_older_than_today

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

fetch_food_info() {
	local id="$1" data name

	data=$(curl "https://fdc.nal.usda.gov/portal-data/external/$id" \
		-H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:123.0) Gecko/20100101 Firefox/123.0' \
		-H 'Accept: application/json, text/plain, */*' \
		-H 'Accept-Language: en-US,en;q=0.5' \
		-H 'Accept-Encoding: gzip, deflate, br' \
		-H 'Connection: keep-alive' \
		-H 'Referer: https://fdc.nal.usda.gov/fdc-app.html' \
		-H 'Sec-Fetch-Dest: empty' \
		-H 'Sec-Fetch-Mode: cors' \
		-H 'Sec-Fetch-Site: same-origin')

	calories=$(jq -r '.foodNutrients | map(select(.nutrient.nutrientUnit.name == "kcal")) | sort_by(-.value)[0].value' <<< "$data")
	name=$(jq -r '.description' <<< "$data")

	echo "$calories|100g|$name"
}

add_new_entry() {
	local query \
		results \
		options \
		food_index \
		food_id \
		new_item \
		new_db \
		time_of_the_day \
		food_info \
		calories \
		portion \
		name

	tmux display-popup -w 65 -h 11 -y 15 -E "$(
		cat - <<EOF
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

	tmux display-popup -w 65 -h 11 -y 15 -E "$(
		cat - <<EOF
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

	food_info="$(fetch_food_info "$food_id")"
	calories="$(awk -F'|' '{ print $1 }' <<<"$food_info")"
	portion="$(awk -F'|' '{ print $2 }' <<<"$food_info")"
	name="$(awk -F'|' '{ print $3 }' <<<"$food_info")"
	new_item="$(
		cat - <<EOF
{
	"name": "$name",
	"id": "$food_id",
	"quantity": "$portion",
	"calories": $calories
}
EOF
	)"

	options="$(
		cat - <<-EOF
			Breakfast
			Lunch
			Dinner
			Extra
		EOF
	)"
	tmux display-popup -w 65 -h 11 -y 15 -E "$(
		cat - <<EOF
	echo "$options" |
		"$SHIFT_PATH" \
		-title " Time of the day " \
		-icon " 󰉜 " \
		-width 65 \
		-height 9 \
		-output "$OUTFILE"
EOF
	)"

	time_of_the_day="$(read_result)"
	new_db=$(jq ".$(tr '[:upper:]' '[:lower:]' <<< "$time_of_the_day") += [$new_item]" "$DATABASE")
	echo "$new_db" >"$DATABASE"

	tsuccess "Entry added :)"
}

case "${1:-add}" in
add)
	add_new_entry
	;;

*)
	terror "Invalid cmd: $1"
	die
	;;
esac
