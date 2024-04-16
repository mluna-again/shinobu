#! /usr/bin/env bash

declare HISTORY_LIMIT=2500 only_pane=0 print_limit=0

usage() {
  cat - <<EOF
Available flags:
  -p: print pane id instead of switching
  -l: print current HISTORY_LIMIT
EOF
}

while getopts "pl" arg; do
  case "$arg" in
    l)
      print_limit=1
      ;;
    p)
      only_pane=1
      ;;
    *)
      usage
      exit 1
    ;;
  esac
done

if [[ "$print_limit" -eq 1 ]]; then
  echo "$HISTORY_LIMIT"
  exit 0
fi

pane=$(while read -r pane; do
	id=$(awk '{print $1}' <<< "$pane")
	name=$(awk '{print $2}' <<< "$pane")

	tmux capture-pane -S -"$HISTORY_LIMIT" -p -t "$id" | awk "\$0 != \"\" {printf \"%s %s %s: %s\n\", \"$id\", NR, \"$name\", \$0 ;}"
done < <(tmux list-panes -a -F "#{pane_id} #{window_name}") | fzf -d " " --with-nth=3.. --height=0 --cycle --preview="tmux capture-pane -e -p -S -$HISTORY_LIMIT -t {1} | grep -i --color=always -C 15 "{q}"")

[ -z "$pane" ] && exit

pane_id=$(awk '{print $1}' <<< "$pane")

if [ "$only_pane" -eq 1 ]; then
  echo "$pane_id"
else
  tmux switch-client -t "$pane_id"
fi
