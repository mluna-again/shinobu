IRB.conf[:PROMPT][:COOL_PROMPT] = {    # name of prompt mode
  :AUTO_INDENT => true,                # enables auto-indent mode
  :PROMPT_I =>  "\033[0;33mλ\033[0m ", # simple prompt
  :PROMPT_S => "\033[0;34mλ\033[0m ",  # prompt for continuated strings
  :PROMPT_C => "\033[0;34mλ\033[0m ",  # prompt for continuated statement
  :RETURN => "==> %s\n"                # format to return value
}

IRB.conf[:PROMPT_MODE] = :COOL_PROMPT
