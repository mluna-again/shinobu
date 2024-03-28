#! /usr/bin/env bash

declare HISTORY_LIMIT=2500

pane=$(while read -r pane; do
	id=$(awk '{print $1}' <<< "$pane")
	name=$(awk '{print $2}' <<< "$pane")

	tmux capture-pane -S -"$HISTORY_LIMIT" -p -t "$id" | awk "\$0 != \"\" {printf \"%s %s %s: %s\n\", \"$id\", NR, \"$name\", \$0 ;}"
done < <(tmux list-panes -a -F "#{pane_id} #{window_name}") | fzf --cycle -i -e --preview="tmux capture-pane -e -p -S -$HISTORY_LIMIT -t {1} | grep -i --color=always -C 15 "{q}"")

[ -z "$pane" ] && exit

pane_id=$(awk '{print $1}' <<< "$pane")
tmux switch-client -t "$pane_id"
