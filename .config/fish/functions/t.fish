function t
    if test -n "$SSH_CONNECTION"
        if pgrep -u "$USER" tmux &>/dev/null
            tmux set -g @force_ssh_indicator true
            tmux attach
            return
        end

        tmux new-session \; set -g @force_ssh_indicator true
        return
    end

    tmux attach; or tmux
end

