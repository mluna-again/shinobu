#! /usr/bin/env sh

icon=""

if [ "$(tmux display -p '#{window_name}')" = "alice" ]; then
	icon="󱩡"
	echo "$icon $1"
	exit
fi

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

	docker)
		icon=""
		;;

	fish)
		icon="󰻳"
		;;

	dotnet)
		icon="󰌛"
		;;

	w3m|lynx)
		icon="󰖟"
		;;

	koi)
		icon="󱩡"
		;;

	*)
		icon=""
esac

echo "$icon $1"
