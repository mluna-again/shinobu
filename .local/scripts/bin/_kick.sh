#! /usr/bin/env bash

: # bash 5+ required
# shellcheck disable=SC2120
die() { [ -n "$*" ] && tostderr "$*"; exit 1; }
info() { printf "%s\n" "$*"; }
tostderr() { tput setaf 1 && printf "%s@%s: %s\n" "$0" "${BASH_LINENO[-2]}" "$*" >&2; tput sgr0; }
assert_installed() { command -v "$1" &>/dev/null || die "$1 is not installed."; }
broken_pipe() { grep -vq "^[0 ]*$" <<< "${PIPESTATUS[*]}"; }

assert_installed fzf

opts=$(who -u | awk '{ printf "%s @ %s (%s %s) [%s]\n", $1, $2, $3, $4, $6 }')

selection=$(fzf <<< "$opts")
[ -z "$selection" ] && die

pid=$(awk '{ print $6 }' <<< "$selection" | sed 's|[][]||g')
[ -z "$pid" ] && die "pid was empty when it shouldn't be"
user=$(awk '{ print $1 }' <<< "$selection")
[ -z "$user" ] && die "user was empty when it shouldn't be"
tty=$(awk '{ print $3 }' <<< "$selection")
[ -z "$tty" ] && die "tty was empty when it shouldn't be"

read -r -p "Final message: " msg
[ -z "$msg" ] && die

info "$msg" | write "$user" "$tty"
broken_pipe && info could not write to user && die

sudo kill "$pid"

info user is gone
