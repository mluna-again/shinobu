function tsuccess
    if test (count $argv) -eq 0
        printf "Prints a success message in tmux status line.\n"
        printf "Usage:\n"
        printf "\ttsuccess 'Hello!'\n"
        return 1
    end

    tmux display -d 0 "#[bg=green,fill=green,fg=black]  Message: $argv"
end
