#! /usr/bin/env bash

# shellcheck disable=SC1091
source "$HOME/.local/scripts/swayutils/_util.sh"

option=$(cat - <<EOF | bemenu
Screenshot
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

  "Screenshot")
    if ! "$HOME/.local/scripts/swayutils/grimshot.sh" copy area; then
      exit_with_error "Failed to take screenshot"
    else
      exit_with_success "Screenshot copied to clipboard"
    fi
    ;;

  "Toggle statusbar")
    swaymsg bar mode toggle || exit_with_error "Failed to toggle statusbar"
    ;;

  *)
    ;;
esac
