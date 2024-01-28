function ask
  gpg -d ~/.cache/gp.gpg ; and nvim -c "GPChatNew split" -c "normal GkA" -c "only"
end
