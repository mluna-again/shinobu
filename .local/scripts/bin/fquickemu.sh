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
	port=$(awk -F, '/ssh/ {print $2}' < "$conf_dir/${conf_dir}.ports") || exit

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
		if ! ssh -o "UserKnownHostsFile=/dev/null" -p "$port" "$CREDS"; then
			2>&1 echo "ssh failed. retrying..."
			sleep 3

			if ! ssh -o "UserKnownHostsFile=/dev/null" -p "$port" "$CREDS"; then
				2>&1 echo "failed to ssh with args: $CREDS"
				2>&1 echo "you can pass different args with: fquickemu.sh user@localhost"
				exit 1
			fi
		fi
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
