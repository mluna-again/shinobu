#!/usr/bin/env fish

set -g show_html_output false

function _print_ihurl_output
    set -g real_query "$query"
    printf "%s\n\n" "$headers"

    if echo "$headers" | grep -iq ": text/html"
        if test $show_html_output = true
            printf "Raw output:\n%s\n" "$body"
        else
            printf "HTML output hidden.\nRun `show` to enable it.\n"
        end
    else
        if echo "$query" | grep -iq '| *save *$'
            set -g real_query (echo "$query" | sed 's/| *save *$//')
        end

        printf "Running: jq '%s'\n" "$real_query"

        echo "$body" | jq "$real_query"; or begin
            printf "Query failed.\n"
            printf "Raw output:\n%s\n" "$body"
        end

        if test "$real_query" != "$query"
            if uname | grep -iq darwin
                echo "$body" | jq -r "$real_query" | pbcopy; and printf "Copied.\n"
            else
               echo "$body" | jq -r "$real_query" | xclip -sel clip; and printf "Copied.\n"
            end
        end
    end
end

function _fetch_ihurl_output
    set -g output (hurl --color -iL "$file" | string collect)
    set -g headers (echo "$output" | awk '{ if (NF == 0) over = 1 } { if (over == 0) { print $0 } }' | string collect)
    set -g body (echo "$output" | awk '{ if (NF == 0) over = 1 } { if (over > 0) { print $0 } }' | string collect)
end

function ihurl
    test -z "$query"; and set -g query "."

    _print_ihurl_output

    while read -g -P "query> " query
        test $status = 0; or set -l should_exit true
        test $query = q; and set -l should_exit true
        test $query = quit; and set -l should_exit true
        if test $query = show
            if test $show_html_output = true
                set -g show_html_output false
            else
                set -g show_html_output true
            end
        end
        test $query = reset; and begin
             _fetch_ihurl_output
             clear
             set -g query "."
             _print_ihurl_output
             continue
        end

        if test $should_exit = true
            if test -n "$TMUX"
                tmux send-keys -t . C-c
                break
            end

            printf "Without tmux you need to manually press Ctrl-c.\n"
            break
        end

        test -z "$query"; and set -g query "."

        clear
        _print_ihurl_output

        if test -n "$TMUX"; and test $query != show
            tmux send-keys -t . "$query"
        end
    end

    # user pressed Ctrl-d
    if test -n "$TMUX"
        tmux send-keys -t . C-c
        exit
    end
    printf "Without tmux you need to manually press Ctrl-c.\n"
end

set -g file $argv[1]
set -g query $argv[2]
_fetch_ihurl_output
ihurl $argv
