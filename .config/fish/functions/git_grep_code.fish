function git_grep_code
  if test -z "$argv[1]"
    echo "missing argument"
    return 1
  end

  git log -S "$argv[1]" --source --all --pretty=format:"%h • %s • %an • %ah" | fzf +s -i -e --preview="git diff {+1}^ {+1} | delta"
end
