#!/usr/bin/env fish

function _print_ihurl_output
    printf "%s\n\n" "$headers"
    printf "Running: jq '%s'\n" "$query"

    echo "$body" | jq "$query"; or begin
        printf "Query failed.\n"
        printf "Raw output:\n%s\n" "$body"
    end
end

function ihurl
    set -g file $argv[1]
    set -g query $argv[2]
    test -z "$query"; and set -g query "."

    set -g output (hurl --color -iL "$file" | string collect)
    set -g headers (echo "$output" | awk '{ if (NF == 0) over = 1 } { if (over == 0) { print $0 } }' | string collect)
    set -g body (echo "$output" | awk '{ if (NF == 0) over = 1 } { if (over > 0) { print $0 } }' | string collect)

    _print_ihurl_output

    while read -g -P "query> " query
        test $status = 0; or set -l should_exit true
        test $query = q; and set -l should_exit true
        test $query = quit; and set -l should_exit true

        if test $should_exit = true
            if test -n "$TMUX"
                tmux send-keys -t . C-c
                break
            end

            talert "Without tmux you need to manually press Ctrl-c."
            break
        end

        test -z "$query"; and set -g query "."

        clear
        _print_ihurl_output

        if test -n "$TMUX"
            tmux send-keys -t . "$query"
        end
    end

    # user pressed Ctrl-d
    if test -n "$TMUX"
        tmux send-keys -t . C-c
        exit
    end
    talert "Without tmux you need to manually press Ctrl-c."
end

ihurl $argv
