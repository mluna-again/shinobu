function dotsH
    test -z "$argv[1]"; and begin
        printf "No file specified.\n"
        return
    end

    set -l log (yadm log --follow --format="%h • %s • %an • %ah" -- "$argv[1]" | fzf --header="Search file history" --preview="yadm diff {+1}^ {+1} -- $argv[1] | delta")

    test -z "$log"; and return

    yadm log -1 (echo "$log" | awk '{ print $1 }')
end
