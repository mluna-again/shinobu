function private
    if test -n "$fish_private_mode"
        set -e fish_private_mode
        return
    end

    set -gx fish_private_mode 1
end
