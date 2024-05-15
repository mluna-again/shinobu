function git_goback
  if test -z "$__FISHGIT_PREV_BRANCH"
    echo "no prev branch found."
    return 1
  end

  git checkout "$__FISHGIT_PREV_BRANCH"; or return
  set -e __FISHGIT_PREV_BRANCH
end
