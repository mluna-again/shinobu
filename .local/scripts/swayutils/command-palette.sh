#! /usr/bin/env bash

option=$(cat - <<EOF | bemenu -i --list 50
Open book
EOF
)

case "$option" in
  "Open book")
    book=$(find "$HOME/Books" -type f -iname "*.pdf" | sed "s|$HOME/Books/||" | bemenu -i --list 50) || exit
    [ -z "$book" ] && exit
    xdg-open "$HOME/Books/$book"
    ;;

  *)
    ;;
esac
