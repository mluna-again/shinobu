#! /bin/sh

amixer get Master | grep -e '[0-9]*%' | awk '{print $4}' | sed 's/\[//g' | sed 's/\]//g' | sed 's/%//g'
