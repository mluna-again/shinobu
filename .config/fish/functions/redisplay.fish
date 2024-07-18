function redisplay
  set -gx DISPLAY (tmux show-env | grep -i display | head -1 | sed 's/^DISPLAY=//')
end
