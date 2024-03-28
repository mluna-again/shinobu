set -g quotes "in the face of ambiguity,\nrefuse the temptation to guess." \
    "don’t let your imagination be\ncrushed by life as a whole." \
    "simple is better than clever." \
    "a strange game. the only \nwinning move is not to play." \
    "simplicity is prerequisite\nfor reliability."

function catsays
    set -l message $argv[1]
    if test -z "$message"
        set message (random choice $quotes)
    end
    if test "$argv[1]" = -
        set message
        while read -lz line
            set -a message $line
        end
    end

    set -l lines (echo $message | string split "\n" | awk 'NF > 0')
    set -l longest_line (echo $message | string split "\n" | sed 's/\t/  /g' | awk '{ if ( length > x ) { x = length } }END{ print x }')
    set -l border (string repeat -n (math $longest_line + 2) "━")
    set -l rborder "┏"
    set -l lborder "┓"

    echo -n "$rborder catsays: "
    echo -n (string repeat -n (math (string length "$border") - 2 - 10) "━")
    echo "$lborder"

    for line in $lines
        set line (echo $line | sed 's/\t/  /g')
        test -z "$line"; and break
        echo "┃"(string pad -w "$longest_line" --right -- "$line")"┃"
    end

    set rborder "┗"
    set lborder "┛"
    echo "$rborder"(string repeat -n (math (string length "$border") - 2) "━")"$lborder"

    echo "\
  \\/
    ／l、
  （ﾟ､ ｡ ７
    l  ~ヽ
    じしf_,)ノ\
  " | string pad -w $longest_line --right
end

