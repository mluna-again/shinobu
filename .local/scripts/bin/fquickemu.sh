#! /usr/bin/env bash

CREDS="${1:-user@localhost}"

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
	exit
fi

quickemu --vm "$vm" --display none || exit

if ! ssh -p "$port" "$CREDS"; then
	2>&1 echo "failed to ssh with args: $CREDS"
	2>&1 echo "you can pass different args with: fquickemu.sh user@localhost"
fi
