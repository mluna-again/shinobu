function dotsP
    yadm pull
    if pgrep tmux &>/dev/null
        "$HOME/.local/scripts/tmux/dots_state.sh" red 100 force
    end
end

