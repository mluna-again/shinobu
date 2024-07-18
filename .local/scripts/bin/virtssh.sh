#! /usr/bin/env bash

user="$1"
if [ -z "$user" ]; then
	>&2 echo missing user
	exit 1
fi

ip=$(sudo virsh net-dhcp-leases default | awk 'NR>2 { printf "%s %s\n", $6, $5 }' | fzf)

[ -z "$ip" ] && exit

ip=$(awk '{print $2}' <<< "$ip" | sed 's|/.*$||')

echo "$user@$ip"
ssh "$user@$ip"
