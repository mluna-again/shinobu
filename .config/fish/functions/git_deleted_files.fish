function git_deleted_files
  git log --all --pretty=format:"%h" --name-only --diff-filter=D | sort -u
end
