function gL
    set -l log (git log --format="%h • %s • %an" | fzf --header="Search git logs" --preview='git diff {+1}^ {+1} | delta')

    test -z "$log"; and return

    git log -1 (echo "$log" | awk '{ print $1 }')
end
