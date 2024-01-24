function _is_docker_running
    docker info; or return 1

    return 0
end

function dock
    _is_docker_running &>/dev/null; or begin
        printf "Docker is not running.\n" 2>&1
        return 1
    end

    set -l cmd $argv[1]
    test -z "$cmd"; and begin
        printf "Available CMDs:\n"
        printf "\tstart\n"
        printf "\trestart\n"
        printf "\tstop\n"
        printf "Usage:\n"
        printf "\tdock <cmd>\n"
        return 1
    end

    switch "$cmd"
        case id
            set -l id (
                docker container ls --format "table {{.ID}}\t{{.Names}}\t{{.Status}}" |\
                    awk 'NR > 1' |\
                    fzf --header="Search container" |\
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
            return 1
    end
end
