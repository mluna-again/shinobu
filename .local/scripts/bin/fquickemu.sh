#! /usr/bin/env bash

CREDS="user@localhost"
DISPLAY_MODE=none
RUN_MODE=run

while true; do
	[ -z "$1" ] && break

	case "$1" in
		--display)
			DISPLAY_MODE=spice
			shift
			;;

		--kill)
			RUN_MODE=kill_vm
			shift
			;;

		*)
			CREDS="$1"
			shift
			;;
	esac
done

run() {
	vm=$(find . -maxdepth 1 -iname "*.conf" | fzf --header="Available configurations") || exit

	[ -z "$vm" ] && exit

	conf_dir=$(sed 's|.conf$||' <<< "$vm") || exit
	conf_dir_clean=$(sed 's|^./||' <<< "$conf_dir") || exit
	port=$(awk -F, '/ssh/ {print $2}' < "$conf_dir/${conf_dir_clean}.ports") || {
		2>&1 echo "ports file not found! is the vm installed yet? (you also need to enable ssh first inside the vm)"
		exit 1
	}

	if [ -z "$port" ]; then
		2>&1 echo "could not find SSH port!"
		exit 1
	fi

	if [[ ! "$port" =~ [0-9]+ ]]; then
		2>&1 echo "port found is in invalid format: $port!"
		exit 1
	fi

	quickemu --vm "$vm" --display "$DISPLAY_MODE" || exit

	if [ "$DISPLAY_MODE" = none ]; then
		ssh -o "UserKnownHostsFile=/dev/null" -p "$port" "$CREDS"
	fi
}

kill_vm() {
	vm=$(find . -maxdepth 1 -iname "*.conf" | fzf --header="Available configurations") || exit

	[ -z "$vm" ] && exit

	quickemu --vm "$vm" --kill
}

case "$RUN_MODE" in
	run)
		run
		;;

	kill_vm)
		kill_vm
		;;

	*)
		2>&1 echo "invalid mode: $RUN_MODE"
		exit 1
		;;
esac
