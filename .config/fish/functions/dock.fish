function _is_docker_running
    docker info; or return 1

    return 0
end

function _try_start_docker_desktop_app
    if not uname | grep -iq linux
        printf "Docker is not running."
        return 1
    end

    printf "Trying to start docker...\n"
    if systemctl --user start docker-desktop
        printf "Docker started, try again.\n"
        return 0
    else
        printf "Docker could not be started.\n" 2>&1
        return 1
    end
end

function dock
    if not _is_docker_running &>/dev/null
        _try_start_docker_desktop_app
        return 0
    end

    set -l cmd $argv[1]
    set -l query $argv[2]
    test -z "$cmd"; and begin
        printf "Available CMDs:\n"
        printf "\tid\n"
        printf "\tlogs\n"
        printf "\tdelete\n"
        printf "\tstart\n"
        printf "\trestart\n"
        printf "\tstatus\n"
        printf "\tstop\n"
        printf "\tports\n"
        printf "\texec\n"
        printf "Usage:\n"
        printf "\tdock <cmd>\n"
        printf "\tdock <cmd> [<initial_query>] # automatically selects first match\n"
        return 1
    end

    switch "$cmd"
        case exec
            set -l shell "$query"
            if test -z "$shell"
                set shell sh
                echo "no shell provided. defaulting to sh" 2>&1
            end

            set -l id (
                docker container ls --format "table {{.ID}}\t{{.Names}}\t{{.Status}}" | awk 'NR > 1' | \
                    fzf --header="Choose container to exec into" | \
                    awk '{print $1}'
            )

            if test -z "$id"
                return 1
            end

            docker container exec --detach-keys="ctrl-@" -it "$id" "$shell"

        case ports
            docker container ls --format "table {{.Names}}\t{{.Ports}}"

        case status
            if test -z "$query"
                echo no argument 2>&1
                return 1
            end

            docker container ls -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}" | awk 'NR > 1' | grep -i "$query" | awk '{ printf "%s: %s\n", $2, $3 }'

        case rm
            set -l id (
                docker container ls -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}" |\
                    awk 'NR > 1' |\
                    fzf -q "$query" -1 --header="Remove container(s)" --multi --bind ctrl-a:select-all |\
                    awk '{print $1}'
            )
            test -z "$id"; and return

            docker container rm --force $id

        case logs
            set -l id (
                docker container ls -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}" |\
                    awk 'NR > 1' |\
                    fzf -q "$query" -1 --header="See container logs" |\
                    awk '{print $1}' |\
                    xargs
            )
            test -z "$id"; and return

            docker container logs "$id"

        case id
            set -l id (
                docker container ls -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}" |\
                    awk 'NR > 1' |\
                    fzf -q "$query" -1 --header="Copy container ID" |\
                    awk '{print $1}' |\
                    xargs
            )

            test -z "$id"; and return
            echo "$id"

            if isatty 1
                echo -n "$id" | fish_clipboard_copy
                echo "Copied to clipboard."
            end

        case exec
            set -l id (
                docker container ls -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}" |\
                    awk 'NR > 1' |\
                    fzf -q "$query" -1 --header="Enter container" |\
                    awk '{print $1}' |\
                    xargs
            )

            test -z "$id"; and return
            set -l shell $argv[2]
            if test -z "$shell"
                set shell bash
            end

            docker container exec -it "$id" "$shell"

        case restart
            set -l container (
                docker container ls --filter status=running --format "table {{.ID}}\t{{.Names}}\t{{.Command}}\t{{.Status}}\t{{.CreatedAt}}" |\
                    awk 'NR > 1' |\
                    fzf -q "$query" -1 --header="Restart container" --multi --bind ctrl-a:select-all |\
                    awk '{print $1}'
            )

            test -z "$container"; and return

            docker container restart $container

        case start
            set -l container (
                docker container ls --filter status=exited --format "table {{.ID}}\t{{.Names}}\t{{.Command}}\t{{.Status}}\t{{.CreatedAt}}" |\
                    awk 'NR > 1' |\
                    fzf -q "$query" -1 --header="Start container" --multi --bind ctrl-a:select-all |\
                    awk '{print $1}'
            )

            test -z "$container"; and return

            docker container start $container

        case stop
            set -l container (
                docker container ls --filter status=running --format "table {{.ID}}\t{{.Names}}\t{{.Command}}\t{{.Status}}\t{{.CreatedAt}}" |\
                    awk 'NR > 1' |\
                    fzf -q "$query" -1 --header="Stop container" --multi --bind ctrl-a:select-all |\
                    awk '{print $1}'
            )

            test -z "$container"; and return

            docker container stop $container

        case '*'
            printf "Invalid command.\n"
            return 1
    end
end
