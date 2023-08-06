#! /usr/bin/env sh

icon=""

case "$2" in
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

	*)
		icon=""
esac

echo "$icon $1"
