#! /usr/bin/env bash
NOTES_PATH="$HOME/Notes"
TEMP_PATH="$NOTES_PATH/.temp"
OUTPUT_FILE="$1"

[ -z "$OUTPUT_FILE" ] && { echo "No output file!"; exit 1; }

[ ! -e "$NOTES_PATH" ] && mkdir "$NOTES_PATH"

[ -e "$TEMP_PATH" ] && rm "$TEMP_PATH"
touch "$TEMP_PATH"

cleanup() {
	[ -e "$TEMP_PATH" ] && rm "$TEMP_PATH"
	exit
}

trap cleanup 1 2 3 6 15

read_result() {
	tail -1 < "$TEMP_PATH"
	exit
}

read_result_with_query() {
	tail -2 < "$TEMP_PATH"
	exit
}

fuzzy() {
	mshift -title " Notes " -input "$1" -height 9 -width 65 -output "$TEMP_PATH" -icon "  "
}

concat_path() {
	echo "$NOTES_PATH/$1.md"
}

list_notes() {
	find "$NOTES_PATH" -type f -not -iname ".temp" | sed "s|$HOME/Notes/||" | sed "s/\.sc$//" | sed "s/.md$//"
}

delete() {
	fuzzy "$(list_notes)"
	name=$(read_result)
	file_path=$(concat_path "$name")
	[ ! -e "$file_path" ] && exit
	rm "$file_path"
}

create() {
	if [ -n "$2" ]; then
		name="$2"
	else
		printf "Name: "
		read -r name
	fi
	file_path=$(concat_path "$name")

	[ -e "$file_path" ] && { echo "File already exists."; exit 1; }

	touch "$file_path"
	echo "$file_path" > "$OUTPUT_FILE"
}

case "$1" in
	delete)
		delete
		;;

	create)
		create "$@"
		;;

	*)
		files=$(list_notes)
		[ -z "$files" ] && { echo "No notes yet, create one!"; create "$@"; exit 1; }

		fuzzy "$files"
		name=$(read_result_with_query)
		query=$(awk 'NR==1' <<< "$name" )
		name=$(awk 'NR==2' <<< "$name" )

		if [ -z "$name" ]; then
			[ -z "$query" ] && exit; # script aborted

			printf "No file named %s, do you want to create it? [yN] " "$query"
			read -r confirmation
			confirmation="$(tr '[:upper:]' '[:lower:]' <<< "$confirmation")"
			[ "$confirmation" = "y" ] || exit

			file_path=$(concat_path "$query")
			touch "$file_path"
			name="$query"
		fi

		file_path=$(concat_path "$name")
		# [ ! -e "$file_path" ] && { echo "File doesn't exist."; exit 1; }
		echo "$file_path" > "$OUTPUT_FILE"
		;;
esac

cleanup
