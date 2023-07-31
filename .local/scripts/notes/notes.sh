#! /usr/bin/env bash
NOTES_PATH="$HOME/Notes"

fzf_with_opts() {
	FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color='bg:236' --header='Search notes'" fzf
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

		name=$(fzf_with_opts <<< "$files")

		[ -z "$name" ] && exit

		file_path=$(concat_path "$name")
		[ ! -e "$file_path" ] && { echo "File doesn't exist."; exit 1; }
		nvim "$file_path"
		;;
esac
