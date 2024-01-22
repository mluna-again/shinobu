function talert
    if test (count $argv) -eq 0
        printf "Prints an alert message in tmux status line.\n"
        printf "Usage:\n"
        printf "\ttalert 'Something important!'\n"
        return 1
    end

    tmux display -d 0 "#[bg=#{@color_info},fill=#{@color_info},fg=black] 󰭺 Message: $argv"
end

