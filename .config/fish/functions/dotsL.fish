function dotsL
    set -l cols (tput cols)
    set -l fsize (math \($cols - 10\) / 2)
    set -l fsize (math floor $fsize)

    set -l log (yadm log --format="%h • %s • %an @ %ad" | fzf --header="Search git logs" --preview="echo {} | fold -w $fsize -s && yadm diff '{+1}~' {+1} | delta")

    test -z "$log"; and return

    set -l log_id (echo "$log" | awk '{ print $1 }')
    yadm diff "$log_id~" "$log_id"

    clear
    yadm log -1 "$log_id"

    echo -n "$log_id" | fish_clipboard_copy
end
