function start_bop
    set -l file "$HOME/.cache/bop"
    test -e "$file"; or begin
        printf "credentials file not found.\nsearched paths: $file\n" > "$HOME/.cache/bop_logs"
        return 1
    end

    set -x SPOTIFY_ID (cat "$file" | awk 'NR == 1')
    set -x SPOTIFY_SECRET (cat "$file" | awk 'NR == 2')
    bop serve; or return $status
end
