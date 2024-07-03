# KANAGAWA
set -l foreground DCD7BA normal
set -l selection 2D4F67 brcyan
set -l comment 727169 brblack
set -l red C34043 red
set -l orange FF9E64 brred
set -l yellow C0A36E yellow
set -l green 76946A green
set -l purple 957FB8 magenta
set -l cyan 7AA89F cyan
set -l pink D27E99 brmagenta

# Syntax Highlighting Colors
set -g fish_color_normal $foreground
set -g fish_color_command $cyan
set -g fish_color_keyword $pink
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_error $red
set -g fish_color_param $purple
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $comment

# Completion Pager Colors
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment

# GENERAL
set -U fish_greeting
set -g fish_key_bindings fish_vi_key_bindings
set -g fish_color_valid_path

# PATH
set -e fish_user_paths
set -U fish_user_paths /usr/local/bin \
    /opt/homebrew/bin \
    /opt/homebrew/sbin \
    "$HOME/.local/go/bin" \
    "$HOME/.local/bin" \
    "$HOME/.dotnet/tools" \
    "$HOME/.cargo/bin" \
    "/usr/local/go/bin" \
    "$HOME/.composer/vendor/bin" \
    "$HOME/.config/composer/vendor/bin" \
    "$HOME/.local/scripts/bin" \
    "$HOME/.symfony5/bin" \
    "$HOME/.nimble/bin" \
    "$HOME/.local/bin/inklecate" \
    "$HOME/.local/share/bob/nvim-bin" \
    "$HOME/.local/bin/odin" \
    "$HOME/.local/bin/flutter/bin" \
    "$HOME/.config/emacs/bin"

function search_dir
    set -l dir (find . -maxdepth 10 | grep -v '^.$' | sed 's|^./||' | fzf --scheme=path --tiebreak=begin)
    if test -z "$dir"
        commandline -f repaint
        return
    end

    if test -d "$dir"
        cd "$dir"
        commandline -f repaint
        return
    end

    nvim "$dir"
    commandline -f repaint
end

function ask_confirmation_exit
    set -l cursor (commandline -C)
    if test "$cursor" -ne 0
        commandline -f repaint
        return
    end

    if test -z "$TMUX"
        exit
    end

    set -l panes (tmux list-panes | wc -l)
    if test "$panes" -gt 1
        exit
    end

    set -l confirmation (read -P "You are inside TMUX, continue? [N/no/yes/y] " | tr '[:upper:]' '[:lower:]')
    if test "$confirmation" != y; and test "$confirmation" != yes
        commandline -f repaint
        return
    end

    exit
end

# BINDINGS
bind -M insert \ce end-of-line
bind -M insert \ca beginning-of-line
bind -M insert \ck accept-autosuggestion
bind -M insert \cp history-search-backward
bind -M insert \cn history-search-forward
bind -M insert \cf search_dir
bind -M insert \cd ask_confirmation_exit
bind -M insert \cb edit_command_buffer
bind --mode insert --sets-mode default jj backward-char repaint

# ENV
set -gx CURL_HOME "$HOME/.config/curl"
set -gx HOMEBREW_NO_AUTO_UPDATE 1
set -gx COLORTERM truecolor
set -gx VISUAL "nvim -u NONE"
set -gx EDITOR "$VISUAL"
set -gx FZF_DEFAULT_COMMAND 'ag -g ""'
set -gx FZF_DEFAULT_OPTS '--ellipsis=... --layout=reverse --prompt=" " --height="100%" --header-first --no-separator --preview-window=border-none --border=none --info=inline-right --pointer="▌" --header="Search" --color="bg:#12120f,preview-bg:#1D1C19,gutter:#12120f,pointer:#c4746e,hl:#c4746e,hl+:#c4746e,bg+:#7a8382,fg:#c5c9c5,fg+:#181816,header:#c4b28a,prompt:#c4b28a,query:#c5c9c5" --cycle --bind="down:preview-down,up:preview-up" --no-scrollbar'
set -gx ELIXIR_ERL_OPTIONS "-kernel shell_history enabled"
set -gx ERL_AFLAGS "-kernel shell_history enabled -kernel shell_history_file_bytes 1024000"
set -gx GOPATH "$HOME/.local/go"
set -gx SHELLCHECK_OPTS "-e SC2001"

# ALIASES
abbr --add pg pgcli -h 127.0.0.1 -u postgres
abbr --add ph iex -S mix phx.server
abbr --add dots yadm
abbr --add dotss yadm status
abbr --add dotsa yadm add -u
abbr --add dotsA yadm add
abbr --add dotsl yadm log
abbr --add dotsC yadm checkout
abbr --add dotsR yadm reset --hard
abbr --add dotsp yadm push
abbr --add dotsd yadm diff
abbr --add dotsdd yadm diff --cached
abbr --add gd git diff
abbr --add gdd git diff --cached
abbr --add gl git log
abbr --add gCC git clean -fd
abbr --add gC git checkout
abbr --add gb "git checkout (git branch --sort=-committerdate -a | sed 's/\*/ /' | fzf | xargs)"
abbr --add gP git pull
abbr --add gp git push
abbr --add gs git status
abbr --add ga git add .
abbr --add gA git add
abbr --add gr git reset --soft
abbr --add gofmt go fmt ./...
abbr --add artisan php artisan
abbr --add sym symfony
abbr --add jcurl curl -sSf -H \"Content-Type: application/json\"
abbr --add ww watchexec -r -c clear
abbr --add hcurl curl -s -o /dev/null -w "%{http_code}"
abbr --add clip fish_clipboard_copy
abbr --add --set-cursor b bash -c \"%
abbr --add dateiso date +"%Y-%m-%dT%H:%M:%S%z"

command -v z &>/dev/null; and function cd
    z $argv
end

command -v eza &>/dev/null; and function ls
    eza --icons -1 $argv
end

command -v eza &>/dev/null; and function ll
    eza --icons -1 -lh $argv
end

command -v bat &>/dev/null; and function cat
    bat --theme kanagawa-dragon $argv
end

if uname | grep -i darwin &>/dev/null
    set -l p (brew --prefix asdf)/libexec/asdf.fish
    test -e "$p"; and source "$p"
else
    set -l p ~/.asdf/asdf.fish
    test -e "$p"; and source "$p"
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    command -v atuin &>/dev/null; and atuin init fish --disable-up-arrow | source
    command -vq fortune; and fortune | catsays -
    command -vq direnv; and direnv hook fish | source
    command -vq zoxide; and zoxide init fish | source
    command -vq starship; and starship init fish | source

    if uname | grep -iq linux && test -z "$TMUX" && test -z "$NVIM" && command -vq tmux
        t
    end
end

# clean up undo nvim files older than 3 days
set -l nvim_undo_dir "$HOME/.local/state/nvim/undo"
test -d "$nvim_undo_dir"; and find "$nvim_undo_dir" -type f -mtime +3 -delete
