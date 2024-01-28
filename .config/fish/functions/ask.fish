function ask
  gpg -d ~/.cache/gp.gpg
  nvim -c "GPChatNew split" -c "normal GkA" -c "only"
end
