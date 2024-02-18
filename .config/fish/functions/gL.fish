function gL
    set -l cols (tput cols)
    set -l fsize (math \($cols - 10\) / 2)
    set -l fsize (math floor $fsize)

    set -l log (git log --format="%h • %s • %an" | fzf --header="Search git logs" --preview="echo {} | fold -w $fsize -s && git diff {+1}^ {+1} | delta")

    test -z "$log"; and return

    git log -1 (echo "$log" | awk '{ print $1 }')
end
