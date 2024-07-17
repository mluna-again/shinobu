#! /usr/bin/env bash

if [ "$#" -eq 0 ]; then
  cat - <<EOF
Usage:
  alert.sh <terminal> <message> [<button>...] # Terminal is used to return focus
  alert.sh "Alacritty" "Hello world, do you want to enter? :)" "Yeah" "Nah"
  > Yeah # returns the button pressed
EOF
  exit 1
fi

TERMINAL_EMULATOR="${1:-Alacritty}"
MESSAGE="$2"
shift
shift
BUTTONS="$*"
buttons="{\"${BUTTONS//[[:space:]]/"\",\""}\"}"
if [ -z "$BUTTONS" ]; then
  buttons='{"Ok"}'
fi

result=$(cat - <<EOF | osascript -
tell app "Finder"
  activate
  display dialog "$MESSAGE" buttons $buttons
end tell
EOF
)

cat - <<EOF | osascript - &>/dev/null || true
tell app "$TERMINAL_EMULATOR"
  activate
end tell
EOF

echo "${result//button returned:/}"
