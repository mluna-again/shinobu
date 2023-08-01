#! /usr/bin/env bash

CACHE_PATH="$HOME/.cache/.i_dont_know_how_to_program_and_my_code_should_be_illegal"
[ ! -e "$CACHE_PATH" ] && exit

eval "$(cat "$CACHE_PATH")"
