#! /usr/bin/env bash

exit_with_error() {
  local msg="$1"

  notify-send -t 5000 -u critical "$msg"
  exit 1
}

exit_with_success() {
  local msg="$1"

  notify-send -t 5000 "$msg"
  exit 0
}
