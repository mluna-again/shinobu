#! /usr/bin/env bash

if uname | grep -i darwin &>/dev/null; then
	top -l 1 | grep -E "^PhysMem"  | awk '{print $2}' | numfmt --to=iec --from=si
else
	free -b | awk 'NR == 2 {print $3}' | numfmt --to=iec --from=si
fi
