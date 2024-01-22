function tsuccess
    if test (count $argv) -eq 0
        printf "Prints a success message in tmux status line.\n"
        printf "Usage:\n"
        printf "\ttsuccess 'Hello!'\n"
        return 1
    end

    tmux display -d 0 "#[bg=#{@color_success},fill=#{@color_success},fg=black]  Message: $argv"
end
