function talert
    if test (count $argv) -eq 0
        printf "Prints an alert message in tmux status line.\n"
        printf "Usage:\n"
        printf "\tterror 'Something important!'\n"
        return 1
    end

    tmux display -d 0 "#[bg=yellow,fill=yellow,fg=black] 󰭺 Message: $argv"
end

