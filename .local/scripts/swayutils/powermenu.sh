#! /usr/bin/env bash

export LC_ALL=en_US.UTF-8
LOCK_CMD="swaylock -f --clock --ignore-empty-password --indicator-caps-lock --indicator --indicator-idle-visible --fade-in 0.3 --effect-vignette 0.5:0.5"

action=$(cat - <<EOF | LD_LIBRARY_PATH=/usr/local/lib BEMENU_RENDERERS=/usr/local/lib/bemenu bemenu --list 50 -i
Lock
Logout
Shutdown
Reboot
EOF
)

case "$action" in
  Lock)
    $LOCK_CMD
    ;;

  Logout)
    swaymsg exit
    ;;

  Shutdown)
    shutdown now
    ;;

  Reboot)
    shutdown -r now
    ;;

  *)
    ;;
esac
