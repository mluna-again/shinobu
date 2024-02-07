#! /usr/bin/env bash

message="And it came to pass that AC learned how to reverse the direction of entropy.
But there was now no man to whom AC might give the answer of the last question. No
matter. The answer -- by demonstration -- would take care of that, too.
For another timeless interval, AC thought how best to do this. Carefully, AC organized
the program.
The consciousness of AC encompassed all of what had once been a Universe and
brooded over what was now Chaos. Step by step, it must be done.
And AC said, \"LET THERE BE LIGHT!\"
And there was light --"
message=$(tr '\n' ' ' <<< "$message")

steps="${1:-1}"
seconds="${2:-0.2}"

start=0
stop=$(tput cols)
stop=$((stop - 10))

while true; do
	tput cuu1
	tput el
	printf '\033[43;30m%s\033[0m' ' NOTE '
	echo -n "  ${message:$start:$stop}  "

	if [ "$start" -eq 0 ]; then
		sleep 1
	else
		sleep "$seconds"
	fi

	start=$((start + steps))
done
