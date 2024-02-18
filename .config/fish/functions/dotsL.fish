function dotsL
    set -l cols (tput cols)
    set -l fsize (math \($cols - 10\) / 2)
    set -l fsize (math floor $fsize)

    set -l log (yadm log --format="%h • %s • %an" | fzf --header="Search git logs" --preview="echo {} | fold -w $fsize -s && yadm diff {+1}^ {+1} | delta")

    test -z "$log"; and return

    yadm log -1 (echo "$log" | awk '{ print $1 }')
end
