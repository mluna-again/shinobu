function dotsc
  if test -z "$argv[1]"
    yadm commit
    return
  end

  yadm commit -m "$argv"
end
