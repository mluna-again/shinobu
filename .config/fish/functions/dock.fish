function _is_docker_running
    docker info; or return 1

    return 0
end

function _try_start_docker_desktop_app
    if not uname | grep -i linux
        printf "Sorry osx user, you are on your own (can't auto-start docker desktop).\n"
        return 1
    end

    printf "Trying to start docker...\n"
    if systemctl --user start docker-desktop
        printf "Docker started.\n"
        return 0
    else
        printf "Docker could not be started.\n" 2>&1
        return 1
    end
end

function _try_hide_docker_desktop_app
    set -l should_close_desktop $argv[1]
    if not test "$should_close_desktop" = true
        return 1
    end

    if not command -vq xdotool
        printf "[xdotool] xdotool is not installed. Install it to autoclose docker-desktop app."
        return 1
    end

    set -l id (xdotool search --name "docker desktop")
    if test "$(echo $id | wc -l)" -ge 2
        printf "[xdotool] too many windows matched 'docker-desktop'. Won't close them to be safe.\n"
        return 1
    end

    xdotool windowclose "$id"
end

function dock
    set -l should_close_desktop false
    # i try to close docker-desktop at the end because by
    # the time the function reaches its end docker-desktop
    # *should* already be running and xdotool will be able
    # to find it
    _is_docker_running &>/dev/null; or begin
        _try_start_docker_desktop_app; and set should_close_desktop true
    end

    set -l cmd $argv[1]
    test -z "$cmd"; and begin
        printf "Available CMDs:\n"
        printf "\tid\n"
        printf "\tlogs\n"
        printf "\tdelete\n"
        printf "\tstart\n"
        printf "\trestart\n"
        printf "\tstop\n"
        printf "Usage:\n"
        printf "\tdock <cmd>\n"
        return 1
    end

    switch "$cmd"
        case rm
            set -l id (
                docker container ls -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}" |\
                    awk 'NR > 1' |\
                    fzf --header="Remove container(s)" --multi --bind ctrl-a:select-all |\
                    awk '{print $1}'
            )
            test -z "$id"; and return

            docker container rm --force $id

        case logs
            set -l id (
                docker container ls -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}" |\
                    awk 'NR > 1' |\
                    fzf --header="See container logs" |\
                    awk '{print $1}' |\
                    xargs
            )
            test -z "$id"; and return

            docker container logs "$id"

        case id
            set -l id (
                docker container ls -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}" |\
                    awk 'NR > 1' |\
                    fzf --header="Copy container ID" |\
                    awk '{print $1}' |\
                    xargs
            )

            test -z "$id"; and return
            echo "$id"

            if isatty 1
                echo -n "$id" | fish_clipboard_copy
                echo "Copied to clipboard."
            end

        case restart
            set -l container (
                docker container ls --filter status=running --format "table {{.ID}}\t{{.Names}}\t{{.Command}}\t{{.Status}}\t{{.CreatedAt}}" |\
                    awk 'NR > 1' |\
                    fzf --header="Restart container" --multi --bind ctrl-a:select-all |\
                    awk '{print $1}'
            )

            test -z "$container"; and return

            docker container restart $container

        case start
            set -l container (
                docker container ls --filter status=exited --format "table {{.ID}}\t{{.Names}}\t{{.Command}}\t{{.Status}}\t{{.CreatedAt}}" |\
                    awk 'NR > 1' |\
                    fzf --header="Start container" --multi --bind ctrl-a:select-all |\
                    awk '{print $1}'
            )

            test -z "$container"; and return

            docker container start $container

        case stop
            set -l container (
                docker container ls --filter status=running --format "table {{.ID}}\t{{.Names}}\t{{.Command}}\t{{.Status}}\t{{.CreatedAt}}" |\
                    awk 'NR > 1' |\
                    fzf --header="Stop container" --multi --bind ctrl-a:select-all |\
                    awk '{print $1}'
            )

            test -z "$container"; and return

            docker container stop $container

        case '*'
            printf "Invalid command.\n"
            _try_hide_docker_desktop_app "$should_close_desktop"
            return 1
    end

    _try_hide_docker_desktop_app "$should_close_desktop"; or true
end
