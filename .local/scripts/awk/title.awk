{
  printf "%s", toupper(substr($0, 1, 1));
  for (i = 2; i <= length($0); i++) {
    prev_char = substr($0, i-1, 1);
    curr_char = substr($0, i, 1);

    if (curr_char == "_" || curr_char == " ") {
      continue
    }
    if (prev_char == "_" || prev_char == " ") {
      printf "%s", toupper(curr_char);
    } else {
      printf "%s", curr_char;
    }
  }
}
