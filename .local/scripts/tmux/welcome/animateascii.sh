#! /usr/bin/env bash

while true; do
	for ascii in ascii/*; do
		cat "$ascii"
		sleep 0.1
		clear
	done
done
