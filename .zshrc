# git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
[ -e ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^k' autosuggest-accept
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
autoload run-help
unset MANPATH # delete if you already modified MANPATH elsewhere in your config
bindkey -v
bindkey -M viins 'jj' vi-cmd-mode
export VI_MODE_SET_CURSOR=true
export MODE_INDICATOR="%F{yellow}[NORMAL]%f"
bindkey "^P" up-line-or-search
bindkey "^N" down-line-or-search
bindkey "^A" vi-beginning-of-line
bindkey "^E" vi-end-of-line
bindkey '^R' history-incremental-search-backward
bindkey '^U' backward-kill-line
bindkey '^Y' yank
zstyle ':completion:*' completer _complete
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
plugins=(vi-mode)
autoload -Uz compinit
compinit
MANPATH="$NPM_PACKAGES/share/man:$MANPATH"
# </Config>

# utils
run() {
  [[ -z "$2" ]] && { nodemon $1 --exec "clear; PYTHONWARNINGS=ignore $1"; return; }

  what=$1
  shift
  nodemon $1 --exec "clear; PYTHONWARNINGS=ignore $what $*"
}
alias q="exit"
command -v exa &>/dev/null && alias ls="exa --icons -1"
command -v exa &>/dev/null && alias ll="exa --icons -lh -1"
alias :q="exit"
alias rice='curl -L rum.sh/ricebowl'
alias rice='curl -L git.io/rice'
alias darkness="cat -p ~/.config/nvim/banners/darkness"
alias p="psql -U postgres"
alias xr="xmonad --recompile && xmonad --restart"
alias ports="sudo lsof -i -P -n | grep -i listen"
alias mux="tmuxinator"
alias getbat="acpi | awk -F ',' '{print \$2}'"
alias lisp="clisp"
alias k="kubectl"
alias cd-="cd -"
alias artisan="php artisan"
alias setclip="xclip -selection c"
alias getclip="xclip -selection c -o"
alias icat="kitty +kitten icat"
alias explorer="xdg-open ."
alias please="sudo"
alias die="exit"
alias cd..="cd .."
alias figlet="figlet -f larry3d"
alias lisp_repl="ros run --eval '(ql:quickload :swank)'  --eval '(swank:create-server :dont-close t)'"
alias jqp="jqp --config ~/.config/jqp/config.yaml"
fv() {
  local file
  file="$(fzf)"

  [ -z "$file" ] && return

  nvim "$file"
}

vid() {
  local file
  file="$(fzf)"

  [ -z "$file" ] && return

  mpv --no-video "$file"
}

# phoenix
alias phs="mix phx.server"

# vim
alias vv="v ~/.vimrc"
alias vz="v ~/.zshrc"
alias vt="v ~/.tmux.conf"
alias vm="v ~/.xmonad/xmonad.hs"
alias v="nvim"

# dotfiles
alias dots='yadm'
alias dotss="dots status"
alias dotsa="dots add -u"
alias dotsA="dots add -u"
alias dotsl="dots log"
alias dotsC="dots checkout"
alias dotsR="dots reset --hard"
alias dotsp="dots push"
alias dotsP="dots pull"
alias dotsb="dots branch"
alias dotsd="dots diff"
alias dotsdd="dots diff --cached"
dotsc() {
  dots commit -m "$*"
}

alias vaup="vagrant up && vagrant ssh"
alias vs="vagrant ssh"
alias vh="vagrant halt"

# git
alias gd="git diff"
alias gl="git log"
gR() {
  echo -n "are you sure? [yN] "
  read r
  res=$(echo $r | tr  "[:upper:]" "[:lower:]")
  if [ "$res" = "y" ]; then
    echo "ok..."
    git reset --hard
  else
    echo "aborting..."
  fi
}
alias gCC="git clean -fd"
alias gC="git checkout"
alias gP="git pull"
alias gp="git push"
alias gs="git status"
alias ga="git add ."
alias gA="git add"
# alias gc="git commit -m"
gc() {
  git commit -m "$*"
}
alias gm="git merge"
alias gmc="git --no-pager diff --name-only --diff-filter=U"
# </Aliases>

# <Function>
gL() {
  log=$(git log --format="%h • %s • %an" | fzf --header="Search git logs" --preview='git diff {+1}^ {+1} | delta')

  [ -z "$log" ] && return

  git log -1 $(awk '{ print $1 }' <<< "$log")
}

dotsL() {
  log=$(yadm log --format="%h • %s • %an" | fzf --header="Search git logs" --preview='yadm diff {+1}^ {+1} | delta')

  [ -z "$log" ] && return

  yadm log -1 $(awk '{ print $1 }' <<< "$log")
}

gH() {
  [ -z "$1" ] && { echo "No file specified."; return; }

  log=$(git log --follow --format="%h • %s • %an" -- "$1" | fzf --header="Search file history" --preview='git diff {+1}^ {+1} | delta')

  [ -z "$log" ] && return

  git log -1 $(awk '{ print $1 }' <<< "$log")
}

dotsH() {
  [ -z "$1" ] && { echo "No file specified."; return; }

  log=$(yadm log --follow --format="%h • %s • %an" -- "$1" | fzf --header="Search file history" --preview='yadm diff {+1}^ {+1} | delta')

  [ -z "$log" ] && return

  yadm log -1 $(awk '{ print $1 }' <<< "$log")
}

yt() {
  link="$1"
  yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" "$link"
}

alias t="tmux attach || tmux"
alias tC="rm -rf $HOME/.cache/resurrect"

paragraph() {
  awk -v RS= "NR==${2:-1}" $1
}

replace_all() {
  local file_regex
  local before
  local after

  file_regex="$1"
  before="$2"
  after="$3"

  [ -n "$file_regex" ] || { echo regex missing; return 1; }
  [ -n "$before" ] || { echo content missing; return 1; }
  [ -n "$after" ] || { echo new content missing; return 1; }

  find -E . -iregex "$file_regex" -exec sed -i '' "s/$before/$after/g" {} \;
}

__check_migrate() {
	[ -x "$(command -v migrate)" ] || { echo "migrate is not installed"; return 1; }
}

go_migrate_create() {
	__check_migrate || return 1

	local _path
	_path=$([ -z "$2" ] && echo "migrations" || echo "$2")
	migrate create -ext sql -dir "$_path" -seq "$1"
}

go_migrate_up() {
	__check_migrate || return 1

	[ -z "$DATABASE_URL" ] && { echo "DB_URL is not set"; return 1; }

	local _path
	_path=$([ -z "$1" ] && echo "migrations" || echo "$1")
	echo $_path
	migrate -database "$DATABASE_URL" -path "$_path" up
}

alias gofmt="go fmt ./..."
goinit() {
  go mod init $(basename $(pwd))
  cat <<EOF >> main.go
  package main

  import "fmt"

  func main() {
    fmt.Println("Hello new world")
  }
EOF
}

git_list_modified() {
  local help_msg
  help_msg="git_list_modified <main_branch> <current_branch>"

  [[ "$1" = "help" ]] && { echo $help_msg && return 1 }

  output=$(git diff --name-only "$2" $(git merge-base "$1" "$2"))

  echo $output
  echo "Total count: $(echo $output | wc -l)"
}

# </Function>

# <Env>
export COLORTERM=truecolor
export VISUAL=nvim
export EDITOR="$VISUAL"
export FZF_DEFAULT_COMMAND='ag -g ""'
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
export PATH=$PATH:$HOME/.config/composer/vendor/bin
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$HOME/.local/share/gem/ruby/3.0.0/bin
export PATH=$PATH:$HOME/.yarn/bin
export SPICETIFY_INSTALL="$HOME/spicetify-cli"
export PATH="$SPICETIFY_INSTALL:$PATH"
export NPM_PACKAGES=$HOME/.npm-packages
export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
export PATH="$NPM_PACKAGES/bin:$PATH"
export PYTHONPATH=/usr/share/python3
# </Env>

# <Load>
eval "$(starship init zsh)"
# </Load>

# <Elixir/Erlang>
elidocs() {
  if grep ":" <<< "$1" &> /dev/null; then
    erl -man "${1:1}" | less
  else
    elixir -e "require IEx.Helpers; IEx.Helpers.h($1)" | less
  fi
}
ph() {
  command="$1"

  [ -z $command ] && iex -S mix phx.server && return
  [ $command = "s" ] && mix phx.server && return

  shift
  eval "mix phx.$command $@"
}

ph_test() {
  nodemon $1 --exec "mix test $1"
}

export ELIXIR_ERL_OPTIONS="-kernel shell_history enabled"
export ERL_AFLAGS="-kernel shell_history enabled -kernel shell_history_file_bytes 1024000"
# </Elixir/Erlang>

export GOPATH="$HOME/.local/go"
export PATH="$PATH:$GOPATH/bin"
export PATH=$PATH:/usr/local/go/bin

export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:/$HOME/.emacs.d/bin"

# fix tmux bg bug
export TERM="xterm-256color"

eval "$(direnv hook zsh)"
eval "$(zoxide init zsh)"

command -v z &>/dev/null && alias cd="z"

ok() {
git commit -m "$* 😑👍"
}

# load profile
[ -e $HOME/.zprofile ] && source $HOME/.zprofile

[ -e $HOME/.asdf/asdf.sh ] && . $HOME/.asdf/asdf.sh

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# node
alias ado="node ace"

command -v rbenv &>/dev/null && eval "$(rbenv init -)" || true

[ -e ~/.personal ] && source ~/.personal || true

# opam configuration
[[ ! -r /Users/mluna/.opam/opam-init/init.zsh ]] || source /Users/mluna/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh" || true

export PATH="$PATH:/Users/mluna/.dotnet/tools"

# ruby
_rails=$(which rails)
rails() {
	[ -e ./bin/rails ] && ./bin/rails "$@" || $_rails "$@"
}
export PATH="$PATH:$HOME/.local/bin/zig"
export FZF_DEFAULT_OPTS='--layout=reverse --prompt=" " --pointer=" " --header-first --color="bg:#181616,bg+:#c4746e,fg+:#1D1C19,gutter:#1D1C19,header:#c4746e,prompt:#c4746e,query:#c5c9c5" --height="95%" --bind ¿:preview-up,-:preview-down'

if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  tmux attach || tmux
fi
