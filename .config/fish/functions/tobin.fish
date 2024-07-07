function tobin
  if test -z $argv
    echo -e "Usage:\ntobin 192 # 11000000"
    return 1
  end

  echo "obase=2;$argv[1]" | bc
end
