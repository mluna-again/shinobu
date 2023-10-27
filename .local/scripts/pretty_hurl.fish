#!/usr/bin/env fish

set -g IGNORED_CMDS show help clear headers

set -g fish_color_error yellow

set -g original_arvg $argv
set -g original_dir (pwd)
set -g file $argv[1]
set -g query $argv[2]
function my_signal_handler --on-signal SIGINT
    if test "$should_exit" = true
        return
    end

    printf "Type `exit` to quit.\n"
    _fetch_ihurl_output
    ihurl $original_arvg
end

# make highlight work for cmds
function watch; end
function unwatch; end
function use; end
function reset; end
function r; end
function reparse; end
function save; end
function show; end
function quit; end
function exit; end
function q; end

set -g show_output true
set -g show_headers true

command -vq jq; or begin
    printf "[ERROR] Requred dependency not installed: jq.\n"
    exit 1
end
command -vq hurl; or begin
    printf "[ERROR] Requred dependency not installed: hurl.\n"
    exit 1
end
command -vq bat; or printf "[WARNING] Optional dependency not installed: bat.\n"
command -vq htmlq; or printf "[WARNING] Optional dependency not installed: htmlq.\n"
command -vq fzf; or printf "[WARNING] Optional dependency not installed: fzf.\n"

function _print_ihurl_help
    printf "Help!\n"
    printf "Available commands:\n"
    printf "  grep: fuzzy find requests in current directory.\n"
    printf "  save: copy jq output to clipboard.\n"
    printf "  echo <var>: print env var.\n"
    printf "  watch <file>: quits ihurl and restarts it in 'watch' mode (tmux only).\n"
    printf "  unwatch: quits ihurl and restarts it in 'interactive' mode (tmux only).\n"
    printf "  env: prints env variables.\n"
    printf "  ls: show files in current directory.\n"
    printf "  cd: change directory.\n"
    printf "  use: change Hurl file and run it.\n"
    printf "  show: toggle output.\n"
    printf "  headers: toggle headers.\n"
    printf "  reset: re-send HTTP request.\n"
    printf "  reparse: re-parse env variables (does not re-send request).\n"
    printf "  exit: quit ihurl.\n"
    printf "  quit: quit ihurl.\n"
    printf "  q: quit ihurl.\n"
    printf "  help: show this message.\n\n"
    printf "  *** save is a special one, you use it at the end of your query like this (only works in jq or env):\n"
    printf "  *** \$ .errors[0].title | save\n"
    printf "  *** \$ env user | save\n\n"
    printf "Note: everything that is not in this list is considered a query to jq for JSON responses.\n"
    printf "Note 2: You can set HURL_* env variables with <key>=<value>\n"
end

function _pretty_print_html
    set -l q $argv[2]
    # ignore original . query for jq
    test "$q" = .; and set -l q ""

    command -vq htmlq; or command -vq bat; or begin
        echo $argv[1]

        test -n "$q"; and printf "[WARNING] htmlq or bat not installed. Query ignored.\n"
        return
    end

    # why won't you check for empty strings bruh.
    # a panic in rust because an empty string is so funny.
    if test -n "$q"
        echo $argv[1] | htmlq -p "$q" | cat -pP -l html --theme kanagawa-dragon
    else
        echo $argv[1] | htmlq -p | cat -pP -l html --theme kanagawa-dragon
    end

    # without this the prompt swallows the last line
    printf "\n"
end

function _print_ihurl_output
    test -z "$file"; and begin
        printf "Select Hurl file.\n"
        return
    end

    set -g real_query "$query"

    if test "$show_headers" = true
        printf "%s\n\n" "$headers"
    else
        # print status code
        printf "%s\n\n" (echo "$headers" | head -1)
    end
    # hurl first line is in green and if i only print that all output will be green
    set_color normal

    if test "$query" = help
        _print_ihurl_help
        return
    end

    set -l content_type (echo "$headers" | grep -i "content-type" | awk -F':' '{print $2}' | xargs)
    if echo "$headers" | head -1 | grep -q 204; and test -z "$body"
        return
    end

    if echo "$headers" | head -1 | grep -q 204; or test -z "$body"
        return
    end

    if echo "$content_type" | grep -iq "text/html"
        if test "$show_output" = true
            printf "HTML output:\n"
            _pretty_print_html "$body" "$query"
        else
            printf "HTML output hidden.\nRun `show` to enable it.\n"
        end
    else if echo "$content_type" | grep -iq "text/plain"
        if test "$show_output" != true
            printf "Plain Text output hidden.\nRun `show` to enable it.\n"
            return
        end
        printf "Plain Text output:\n%s\n" "$body"

    else if echo "$content_type" | grep -iq "application/json"
        if test "$show_output" != true
            printf "JSON output hidden.\nRun `show` to enable it.\n"
            return
        end

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
            echo "$body" | jq -r "$real_query" | fish_clipboard_copy
            printf "Copied.\n"
        end
    else
        if test "$show_output" != true
            printf "Output hidden.\nRun `show` to enable it.\n"
            return
        end

        printf "Unknown content-type: %s.\n" "$content_type"
        printf "Raw output:\n%s\n" "$body"
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

    while read -g -S -P "\$ " query
        set -l query (echo "$query" | sed 's/ *$//')
        set -l original_query "$query"

        test "$status" = 0; or set -g should_exit true
        test "$query" = q; and set -g should_exit true
        test "$query" = quit; and set -g should_exit true
        test "$query" = exit; and set -g should_exit true

        if echo "$query" | grep -Eq '^[a-zA-Z]+="?[a-zA-Z0-9_-]+"?$'
            set -l key HURL_(echo "$query" | awk -F'=' '{print $1}')
            set -l value (echo "$query" | awk -F'=' '{print $2}' | sed 's/^"//' | sed 's/"$//')

            set -x "$key" "$value"
            printf "%s=%s\n" "$key" "$value"
            continue
        end

        if echo "$query" | grep -Eq '^[a-zA-Z]+='
            set -l key HURL_(echo "$query" | awk -F'=' '{print $1}')
            set -x "$key"
            printf "%s=\n" "$key"
            continue
        end

        if echo "$query" | grep -q '='
            printf "Invalid assignment. Usage: <name>=<value>.\n"
            continue
        end

        echo "$query" | grep -iq '^echo '; and begin
            set -l v (echo "$query" | awk '{$1=""; print $0}' | xargs | sed 's/^\$//')
            set -l value (env | grep -i "$v" | head -1 | awk -F'=' '{print $2}')
            printf "%s\n" "$value"
            continue
        end

        if test "$query" = grep
            if not command -vq fzf
                printf "fzf is not installed.\n"
                continue
            end

            set -l file (find . -type f -iname '*.hurl' | sed 's|^./||' | fzf)

            test -z "$file"; and continue

            set -g file (pwd)/"$file"
            clear
            _fetch_ihurl_output
            set -g query "."
            _print_ihurl_output
            continue
        end

        if test "$query" = cd
            builtin cd "$original_dir"
            continue
        end

        echo "$query" | grep -iq '^cd\.\.'; and begin
            builtin cd ..
            continue
        end
        echo "$query" | grep -iq '^cd '; and begin
            set -l dir (echo "$query" | awk '{$1=""; print $0}' | xargs)
            if test -d "$dir"
                builtin cd "$dir"
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
            ls -a
            continue
        end
        test "$query" = pwd; and begin
            set -l current (builtin pwd)
            test -z "$file"; and set -l file "<no request selected>"
            printf "%s (%s)\n" "$current" "$file"
            continue
        end

        test "$query" = reparse; and begin
            set -l current_env (pwd)/.env
            set -l current_envrc (pwd)/.envrc
            set -l root_env "$original_dir/.env"
            set -l root_envrc "$original_dir/.envrc"

            test -e "$current_env"; or test -e "$current_envrc"; or test -e "$root_env"; or test -e "$root_envrc"; or begin
                printf "No .env or .envrc file found.\n"
                printf "Locations searched:\n1. %s\n2. %s\n3. %s\n4. %s\n" "$current_env" "$current_envrc" "$root_env" "$root_envrc"
                continue
            end

            set -l file (pwd)/.env
            test -e "$file"; or set -l file (pwd)/.envrc
            test -e "$file"; or set -l file "$original_dir/.env"
            test -e "$file"; or set -l file "$original_dir/.envrc"

            for args in (sed 's/^ *export //' "$file")
                set -l key (printf "%s" "$args" | awk -F= '{print $1}')
                set -l value (printf "%s" "$args" | awk -F= '{print $2}' | sed 's/^"//' | sed 's/"$//')

                set -x "$key" "$value"
            end

            printf "Env reloaded (%s).\n" "$file"
            continue
        end

        if test "$query" = headers
            if test "$show_headers" = true
                set -g show_headers false
            else
                set -g show_headers true
            end
            if test "$show_output" = true
                set -g query "."
            else
                set -g query ""
            end
            clear
            _print_ihurl_output
            continue
        end

        if test "$query" = show
            if test $show_output = true
                set -g show_output false
                set -g query ""
            else
                set -g show_output true
                set -g query "."
            end
            clear
            _print_ihurl_output
            continue
        end
        test "$query" = reset; or test "$query" = r; and begin
             clear
             _fetch_ihurl_output
             set -g query "."
             _print_ihurl_output
             continue
        end

        test "$query" = help; and begin
            _print_ihurl_help
            continue
        end

        if echo "$query" | grep -iq '^env'
            set -l var (echo "$query" | awk '{print $2}')
            test "$var" = '|'; and set -l var

            if test -n "$var"
                set -l value (env | grep -i --color=never "HURL_$var")

                if echo "$query" | grep -iq '| *save *$'
                    set -l v (echo "$value" | awk -F'=' '{print $2}')
                    echo "$v" | fish_clipboard_copy
                    printf "Copied %s.\n" "$v"
                end

                printf "%s\n" "$value"
                continue
            end

            if uname | grep -iq darwin
                env | grep --color=never '^HURL' | xargs -S 500 -I{} printf "%s\n\n" {}
            else
                env | grep --color=never '^HURL' | xargs -I{} printf "%s\n\n" {}
            end
            continue
        end

        test "$query" = clear; and begin
            clear
            continue
        end

        test "$query" = unwatch; and begin
            if test -z "$TMUX"
                printf "This command is only available inside tmux.\n"
                continue
            end

            if test -z "$file"
                printf "Not watching any file.\n"
                continue
            end

            tmux send-keys -t . C-c C-l ihurl Enter
        end

        echo "$query" | grep -iq '^watch'; and begin
            set -l f (echo "$query" | awk '{$1=""; print $0}' | xargs)
            test -z "$f"; and set -l f "$file"
            set -l path (pwd)/"$f"

            test -e "$path"; or begin
                printf "File doesn't exist.\n"
                continue
            end

            echo "$path" | grep -iqv '\.hurl$'; and begin
                printf "Not a Hurl file (%s).\n" "$path"
                continue
            end

            if test -z "$TMUX"
                printf "This command is only available inside tmux.\n"
                continue
            end

            set -l relative_path (echo "$path" | sed "s|^$original_dir||" | sed 's|^/*||')
            tmux send-keys -t . C-c C-l ihurl Space "$relative_path" Enter
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

        if test -n "$TMUX"; and not contains "$original_query" $IGNORED_CMDS
            tmux send-keys -t . "$query"
        end
    end

    set -g should_exit true
end

_fetch_ihurl_output
ihurl $argv
