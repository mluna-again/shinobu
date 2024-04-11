function gH
    test -z "$argv[1]"; and begin
        printf "No file specified.\n"
        return
    end

    set -l cols (tput cols)
    set -l fsize (math \($cols - 10\) / 2)
    set -l fsize (math floor $fsize)

    set -l log (git log --follow --format="%h • %s • %an • %ah" -- "$argv[1]" | fzf +s -i -e --header="Search file history" --preview="echo {} | fold -w $fsize -s && git diff {+1}^ {+1} -- $argv[1] | delta")

    test -z "$log"; and return

    git log -1 (echo "$log" | awk '{ print $1 }')
end
