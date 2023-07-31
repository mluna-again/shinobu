#! /usr/bin/env bash
NOTES_PATH="$HOME/Notes"

fzf_with_opts() {
	FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color='bg:236' --header='Search notes'" fzf
}

fzf_with_opts_and_query() {
	FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color='bg:236' --header='Search notes'" fzf --print-query
}

concat_path() {
	echo "$NOTES_PATH/$1"
}

list_notes() {
	find "$NOTES_PATH" -type f | sed "s|$HOME/Notes/||"
}

delete() {
	name=$(fzf_with_opts <<< "$(list_notes)")
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
	nvim "$file_path"
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

		name=$(fzf_with_opts_and_query <<< "$files")
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
		[ ! -e "$file_path" ] && { echo "File doesn't exist."; exit 1; }
		nvim "$file_path"
		;;
esac
