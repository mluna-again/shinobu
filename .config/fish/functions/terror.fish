function terror
    if test (count $argv) -eq 0
        printf "Prints an error message in tmux status line.\n"
        printf "Usage:\n"
        printf "\tterror 'Something went wrong!'\n"
        return 1
    end

    tmux display -d 0 "#[bg=#{@color_error},fill=#{@color_error},fg=black]  Message: $argv"
end
