#! /usr/bin/env sh

icon=""

case "$(printf "%s" "$2" | tr '[:upper:]' '[:lower:]')" in
	nvim)
		icon=""
		;;

	mpv)
		icon="󰃽"
		;;

	*spotify*)
		icon=""
		;;

	go)
		icon=""
		;;

	ruby)
		icon=""
		;;

	*cargo*)
		icon=""
		;;

	*beam.smp*)
		icon=""
		;;

	psql)
		icon=""
		;;

	python)
		icon="󰌠"
		;;

	fish)
		icon="󰈺"
		;;

	dotnet)
		icon="󰌛"
		;;

	*)
		icon=""
esac

# echo "$icon $1"
echo "$1"
