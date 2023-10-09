if status is-interactive
    # Commands to run in interactive sessions can go here
    command -v atuin &>/dev/null; and atuin init fish | source
end

# GENERAL
set -U fish_greeting
set -g fish_key_bindings fish_vi_key_bindings

# PATH
set -U fish_user_paths /usr/local/bin $fish_user_paths
set -U fish_user_paths /opt/homebrew/bin $fish_user_paths
set -U fish_user_paths "$HOME/.local/go/bin" $fish_user_paths
set -U fish_user_paths "$HOME/.local/bin" $fish_user_paths
set -U fish_user_paths "$HOME/.dotnet/tools" $fish_user_paths
set -U fish_user_paths "$HOME/.cargo/bin" $fish_user_paths
set -U fish_user_paths "/usr/local/go/bin" $fish_user_paths

# BINDINGS
bind -M insert \ce end-of-line
bind -M insert \ca beginning-of-line
bind -M insert \ck accept-autosuggestion
bind -M insert \cp history-search-backward
bind -M insert \cn history-search-forward

# ENV
set -gx HOMEBREW_NO_AUTO_UPDATE 1
set -gx COLORTERM truecolor
set -gx VISUAL nvim
set -gx EDITOR "$VISUAL"
set -gx FZF_DEFAULT_COMMAND 'ag -g ""'
set -gx FZF_DEFAULT_OPTS '--layout=reverse --prompt=" " --pointer=" " --header-first --color="bg:#181616,bg+:#c4746e,fg+:#1D1C19,gutter:#1D1C19,header:#c4746e,prompt:#c4746e,query:#c5c9c5" --height="95%" --bind ¿:preview-up,-:preview-down'
set -gx ELIXIR_ERL_OPTIONS "-kernel shell_history enabled"
set -gx ERL_AFLAGS "-kernel shell_history enabled -kernel shell_history_file_bytes 1024000"
set -gx GOPATH "$HOME/.local/go"
set -gx SHELLCHECK_OPTS "-e SC2001"

# FUNCTIONS
command -v z &>/dev/null; and function cd
    z $argv
end

command -v exa &>/dev/null; and function ls
    exa --icons -1 $argv
end

command -v exa &>/dev/null; and function ll
    exa --icons -1 -lh $argv
end

command -v bat &>/dev/null; and function cat
    bat $argv
end

function q
    exit
end

function p
    psql -U postgres $argv
end

function cd..
    cd ..
end

function cd-
    cd -
end

function setclip
    xclip -selection c
end

function getclip
    xclip -selection -o
end

function die
    exit
end

function jqp
    command jqp --config ~/.config/jqp/config.yaml $argv
end

function phurl
    ~/.local/scripts/pretty_hurl.sh $argv
end

function ihurl
    watchexec -c clear -r "~/.local/scripts/pretty_hurl.sh $argv"
end

function vid
    set -l file (fzf)
    test -z $file; and return

    mpv --no-video $file
end

function ph
    iex -S mix phx.server
end

function v
    nvim $argv
end

function dots
    yadm $argv
end

function dotss
    yadm status
end

function dotsa
    yadm add -u
end

function dotsA
    yadm add -u
end

function dotsl
    yadm log $argv
end

function dotsC
    yadm checkout $argv
end

function dotsR
    yadm reset --hard
end

function dotsp
    yadm push $argv
end

function dotsP
    yadm pull $argv
end

function dotsd
    yadm diff $argv
end

function dotsdd
    yadm diff --cached $argv
end

function dotsc
    yadm commit -m "$argv"
end

function gd
    git diff $argv
end

function gdd
    git diff --cached $argv
end

function gl
    git log $argv
end

function gR
    read -l -P "are you sure? [yN] " response
    set -l response (echo "$response" | tr '[:upper:]' '[:lower:]')
    if test "$response" != y
        printf "aborting...\n"
        return
    end

    printf "ok...\n"
    git reset --hard
end

function gCC
    git clean -fd
end

function gC
    git checkout
end

function gP
    git pull $argv
end

function gp
    git push $argv
end

function gs
    git status $argv
end

function ga
    git add .
end

function gA
    git add $argv
end

function gc
    git commit -m "$argv"
end

function gL
    set -l log (git log --format="%h • %s • %an" | fzf --header="Search git logs" --preview='git diff {+1}^ {+1} | delta')

    test -z "$log"; and return

    git log -1 (echo "$log" | awk '{ print $1 }')
end

function dotsL
    set -l log (yadm log --format="%h • %s • %an" | fzf --header="Search git logs" --preview='git diff {+1}^ {+1} | delta')

    test -z "$log"; and return

    yadm log -1 (echo "$log" | awk '{ print $1 }')
end

function gH
    test -z "$argv[1]"; and begin
        printf "No file specified.\n"
        return
    end

    set -l log (git log --follow --format="%h • %s • %an" -- "$argv[1]" | fzf --header="Search file history" --preview='git diff {+1}^ {+1} | delta')

    test -z "$log"; and return

    git log -1 (echo "$log" | awk '{ print $1 }')
end

function dotsH
    test -z "$argv[1]"; and begin
        printf "No file specified.\n"
        return
    end

    set -l log (yadm log --follow --format="%h • %s • %an" -- "$argv[1]" | fzf --header="Search file history" --preview='yadm diff {+1}^ {+1} | delta')

    test -z "$log"; and return

    yadm log -1 (echo "$log" | awk '{ print $1 }')
end

function yt
    set -l link $argv[1]
    yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" "$link"
end

function t
    tmux attach; or tmux
end

function gofmt
    go fmt ./...
end

direnv hook fish | source
zoxide init fish | source
starship init fish | source
