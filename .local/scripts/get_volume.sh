#! /bin/sh

amixer get Master | grep -e '[0-9]*%' | sed 1q | awk '{print $(NF - 1)}' | sed 's/\[//g' | sed 's/\]//g' | sed 's/%//g'
