#! /usr/bin/env bash

exit_with_error() {
  local msg="$1"

   notify-send -t 5000 -u critical "$msg"
  exit 1
}
