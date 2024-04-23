function gc
  if test -z "$argv[1]"
    git commit
    return
  end

  git commit -m "$argv"
end
