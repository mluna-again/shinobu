function ssh
    tmux set status-position bottom &>/dev/null
    tmux set @force_ssh_indicator true &>/dev/null
    command ssh $argv
    tmux set status-position top &>/dev/null
    tmux set @force_ssh_indicator false &>/dev/null
end

