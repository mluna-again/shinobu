#! /usr/bin/env bash

exit_with_error() {
  local msg="$1"

   notify-send -t 5000 -u critical "$msg"
  exit 1
}

option=$(cat - <<EOF | bemenu
Open book
Toggle statusbar
EOF
)

case "$option" in
  "Open book")
    book=$(find "$HOME/Books" -type f -iname "*.pdf" | sed "s|$HOME/Books/||" | bemenu) || exit
    [ -z "$book" ] && exit
    xdg-open "$HOME/Books/$book"
    ;;

  "Toggle statusbar")
    swaymsg bar mode toggle || exit_with_message "Failed to toggle statusbar"
    ;;

  *)
    ;;
esac
