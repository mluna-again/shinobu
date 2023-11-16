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
    if test $argv[1] = -
        set message
        while read -lz line
            set -a message $line
        end
    end

    set -l lines (echo $message | string split "\n")
    set -l longest_line (echo $message | awk '{ if ( length > x ) { x = length } }END{ print x }')
    set -l border (string repeat -n (math $longest_line + 2) "-")

    echo "$border"

    for line in $lines
        set line (echo $line | sed 's/\t/  /g')
        echo "|"(string pad -w "$longest_line" --right -- "$line")"|"
    end

    echo "$border"

    echo "\
                           \\/
                              ／l、
                            （ﾟ､ ｡ ７
                              l  ~ヽ
                              じしf_,)ノ\
  " | string pad -w $longest_line --right
end

