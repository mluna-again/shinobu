function ask
  if test $argv[1] = "-"
    gpg -d ~/.cache/gp.gpg
    return
  end

  gpg -d ~/.cache/gp.gpg ; and nvim -c "GPChatNew split" -c "normal GkA" -c "only"
end
