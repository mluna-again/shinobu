function gR
    read -l -P "are you sure? [yN] " response
    set -l response (echo "$response" | tr '[:upper:]' '[:lower:]')
    if test "$response" != y
        printf "aborting...\n"
        return
    end

    printf "ok...\n"
    git reset --hard
end

