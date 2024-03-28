#! /usr/bin/env bash

pane=$(while read -r pane; do
	id=$(awk '{print $1}' <<< "$pane")
	name=$(awk '{print $2}' <<< "$pane")

	tmux capture-pane -S -1000 -p -t "$id" | awk "\$0 != \"\" {printf \"%s %s %s: %s\n\", \"$id\", NR, \"$name\", \$0 ;}"
done < <(tmux list-panes -a -F "#{pane_id} #{window_name}") | fzf --cycle -i -e --preview="tmux capture-pane -e -p -S -1000 -t {1} | grep -i --color=always -C 15 "{q}"")

[ -z "$pane" ] && exit

pane_id=$(awk '{print $1}' <<< "$pane")
tmux switch-client -t "$pane_id"
