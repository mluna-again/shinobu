#! /bin/sh

if [ $1 -lt 100 ]; then
	date "+ %I:%M %p "
else
	date "+ %I:%M %p | %a %d, %b %y "
fi
