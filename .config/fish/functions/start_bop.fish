function _compile_bop_binary
    command -v go &>/dev/null; or begin
        printf "go is not installed!\n"
        return 1
    end
    printf "compiling bop...\n"

    go build $argv[1]
end

function _find_bop_credentials
    set -l file "$HOME/.cache/bop"
    test -e "$file"; or begin
        printf "credentials file not found.\nsearched paths: $file\n"
        return 1
    end

    set -x SPOTIFY_ID (cat "$file" | awk 'NR == 1')
    set -x SPOTIFY_SECRET (cat "$file" | awk 'NR == 2')
    $argv[1]
end

function start_bop
    set -l bop_path "$HOME/.local/scripts/bop"
    cd "$bop_path"

    pgrep bop &>/dev/null; and begin
        printf "bop is already running.\n"
        return 1
    end

    if test "$argv[1]" = dev
        printf "dev mode\n"
        _compile_bop_binary "$bop_path"; or return $status
    else
        test -e "$bop_path/bop"; or begin
            _compile_bop_binary "$bop_path"; or return $status
        end
    end

    printf "waking bop up...\n"

    _find_bop_credentials "$bop_path/bop"; or return $status
end
