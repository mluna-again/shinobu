function dotsL
    set -l log (yadm log --format="%h • %s • %an" | fzf --header="Search git logs" --preview='git diff {+1}^ {+1} | delta')

    test -z "$log"; and return

    yadm log -1 (echo "$log" | awk '{ print $1 }')
end
