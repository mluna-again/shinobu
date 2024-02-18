function vid
    set -l file (fzf)
    test -z $file; and return

    mpv --no-video $file
end

