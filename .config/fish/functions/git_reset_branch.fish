function git_reset_branch
  if test -z "$argv[1]"
    echo "Missing branch."
    return
  end

  set -l branch "$argv[1]"
  set -l commit_count (git cherry "$branch" | wc -l)

  git reset --soft "HEAD~$commit_count"
end
