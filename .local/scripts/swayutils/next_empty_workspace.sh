#! /usr/bin/env bash

# shellcheck disable=SC1091
source "$HOME/.local/scripts/swayutils/_util.sh"

current_workspace_number=$(swaymsg -t get_workspaces | jq 'length') || exit_with_error "Failed to fetch workspaces"
[ -z "$current_workspace_number" ] && exit_with_error "Workspaces are empty but they should not be!"

next_workspace=$(( current_workspace_number + 1 ))

swaymsg workspace number "$next_workspace" || exit_with_error "Failed to switch workspace"
