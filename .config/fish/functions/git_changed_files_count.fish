function git_changed_files_count
  git diff --cached --numstat | wc -l
end
