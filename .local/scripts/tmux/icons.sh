#! /usr/bin/env sh

icon=""

case "$2" in
	nvim)
		icon=""
		;;

	*)
		icon=""
esac

echo "$icon $1"
