#! /usr/bin/env bash

# inspiration: https://github.com/ldelossa/sway-fzfify/blob/main/sway-tree-switcher

exit_with_error() {
  local msg="$1"

   notify-send -t 5000 -u critical "$msg"
  exit 1
}

windows=$(swaymsg -t get_tree | jq -r 'recurse(.nodes[]?) | recurse(.floating_nodes[]?) | select(.type=="con"), select(.type=="floating_con") | select((.app_id != null) or .name != null) | {id, app_id, name, window_properties} | "\(.id) \(.window_properties.instance // .app_id) \(.name)"') || exit_with_error "Failed to retrieve windows"

window=$(bemenu <<< "$windows")
bemenu_code="$?"
if [ "$bemenu_code" -ne 0 ] && [ "$bemenu_code" -ne 1 ]; then
  exit_with_error "Failed to display windows"
fi
[ -z "$window" ] && exit

window_id=$(awk '{print $1}' <<< "$window") || exit_with_error "Failed to parse response"

swaymsg "[con_id=$window_id]" focus || exit_with_error "Failed to switch window"
