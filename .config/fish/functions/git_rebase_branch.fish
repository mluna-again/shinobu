function git_rebase_branch
  set -l branch "$argv[1]"
  if test -z "$branch"
    echo "Missing branch."
    return 1
  end

  set -l remote "$argv[2]"
  set -l remotes_count (git remote | wc -l)
  if test "$remotes_count" -gt 1; and test -z "$remote"
    echo "Multiple remotes. Missing remote."
    return 1
  end
  test -z "$remote"; and set remote origin

  set -l current_branch (git rev-parse --abbrev-ref HEAD)

  git checkout "$branch"
  git pull "$remote"
  git checkout "$current_branch"
  git rebase "$branch"
end
