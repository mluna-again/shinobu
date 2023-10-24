#!/usr/bin/env fish

set -g show_html_output false

function _print_ihurl_help
    printf "Help!\n"
    printf "Available commands:\n"
    printf "  save: copy jq output to clipboard.\n"
    printf "  ls: show files in current directory.\n"
    printf "  cd: change directory.\n"
    printf "  use: change Hurl file and run it.\n"
    printf "  show: toggle HTML output.\n"
    printf "  reset: re-send HTTP request.\n"
    printf "  exit: quit ihurl.\n"
    printf "  quit: quit ihurl.\n"
    printf "  q: quit ihurl.\n"
    printf "  help: show this message.\n"
    printf "save is a special one, you use it at the end of your query like this:\n"
    printf "query> .errors[0].title | save\n"
    printf "\n"
end

function _print_ihurl_output
    test -z "$file"; and begin
        printf "Select Hurl file.\n"
        return
    end

    set -g real_query "$query"
    printf "%s\n\n" "$headers"
    if test "$query" = help
        _print_ihurl_help
        return
    end

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

        if test -z "$real_query"
            printf "Body output hidden.\n"
            return
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
    test -z "$file"; and begin
        return
    end

    set -g output (hurl --color -iL "$file" | string collect)
    set -g headers (echo "$output" | awk '{ if (NF == 0) over = 1 } { if (over == 0) { print $0 } }' | string collect)
    set -g body (echo "$output" | awk '{ if (NF == 0) over = 1 } { if (over > 0) { print $0 } }' | string collect)
end

function ihurl
    test -z "$query"; and set -g query "."

    printf "Use `help` for help :)\n"
    _print_ihurl_output

    while read -g -S -P "query> " query
        test "$status" = 0; or set -l should_exit true
        test "$query" = q; and set -l should_exit true
        test "$query" = quit; and set -l should_exit true
        test "$query" = exit; and set -l should_exit true

        echo "$query" | grep -iq '^cd\.\.'; and begin
            builtin cd ..
            clear
            set -g query "."
            _print_ihurl_output
            continue
        end
        echo "$query" | grep -iq '^cd '; and begin
            set -l dir (echo "$query" | awk '{$1=""; print $0}' | xargs)
            if test -d "$dir"
                builtin cd "$dir"
                clear
                set -g query "."
                _print_ihurl_output
                continue
            else
                printf "Directory doesn't exist.\n"
                continue
            end
        end
        echo "$query" | grep -iq '^use'; and begin
            set -l new_file (echo "$query" | awk '{$1=""; print $0}' | xargs)

            if test -e "./$new_file"
                set -g file "$new_file"
                clear
                _fetch_ihurl_output
                set -g query "."
                _print_ihurl_output
                continue
            else
                printf "File doesn't exist.\n"
                continue
            end
        end
        test "$query" = ls; and begin
            ls
            continue
        end
        test "$query" = pwd; and begin
            set -l current (builtin pwd)
            printf "%s (%s)\n" "$current" "$file"
            continue
        end

        if test "$query" = show
            if test $show_html_output = true
                set -g show_html_output false
            else
                set -g show_html_output true
            end
        end
        test "$query" = reset; and begin
             clear
             _fetch_ihurl_output
             set -g query "."
             _print_ihurl_output
             continue
        end

        if test "$should_exit" = true
            if test -n "$TMUX"
                tmux send-keys -t . C-c
                break
            end

            printf "Without tmux you need to manually press Ctrl-c.\n"
            break
        end

        clear
        _print_ihurl_output

        if test -n "$TMUX"; and test $query != show; and test $query != help
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
