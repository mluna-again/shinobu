function git_goto
  if test -z "$argv[1]"
    echo "missing branch."
    return 1
  end

  if test -n "$__FISHGIT_PREV_BRANCH"
    echo "you need to use git_goback or unset prev branch variable."
    return 1
  end

  set -l branch (git rev-parse --abbrev-ref HEAD)
  git checkout "$argv[1]"; or return

  echo "Saving previous branch..."
  set -g __FISHGIT_PREV_BRANCH "$branch"
end
