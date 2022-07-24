# <Config>
[ -e ~/.personal ] && source ~/.personal

# git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
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
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'
autoload -Uz compinit
compinit
# ZSH_THEME="rei"
plugins=(vi-mode)
MANPATH="$NPM_PACKAGES/share/man:$MANPATH"
# </Config>

# utils
alias cd="z"
alias .="source ~/.zshrc"
alias :q="exit"
alias ls="exa --color always --icons"
alias rice='curl -L rum.sh/ricebowl'
alias rice='curl -L git.io/rice'
alias darkness="cat -p ~/.config/nvim/banners/darkness"
alias figlet="figlet -f ~/.local/share/fonts/figlet-fonts/smmono12.tlf"
alias cat="bat"
alias p="psql -U postgres"
alias xr="xmonad --recompile && xmonad --restart"
alias ports="sudo lsof -i -P -n | grep -i listen"
alias mux="tmuxinator"
alias n="nordvpn"
alias ns="nordvpn status"
alias nc="nordvpn connect"
alias nd="nordvpn disconnect"
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

# scripts
alias mari_says="ruby ~/Repos/mari/mari.rb"

# ruby
alias r="bin/rails"

# phoenix
alias phs="mix phx.server"

# node
alias ado="node ace"
alias npmd="npm run dev"
alias npms="npm start"
alias npmt="npm run test"
alias npmb="npm run build"
alias npmi="npm install"
alias yarns="yarn dev || yarn start"
alias yarnd="yarn start"
alias yarnb="yarn build"
alias yarni="yarn install"
alias yarna="yarn add"
alias drun="deno run --unstable --watch"

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
alias dotsl="dots log"
alias dotsC="dots checkout"
alias dotsR="dots reset --hard"
alias dotsp="dots push"
alias dotsb="dots branch"
alias dotsd="dots diff"
dotsc() {
  dots commit -m "$*"
}

alias vaup="vagrant up && vagrant ssh"
alias vs="vagrant ssh"
alias vh="vagrant halt"

# git
alias gd="git diff"
alias gl="git log"
alias gR="git reset --hard"
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
t() {
  tmuxinator start && return || clear && tmux
}

how() {
  curl cht.sh/$1/$2
}

db_postgres() {
  docker container run -p 5432:5432 --name postgres -e POSTGRES_PASSWORD=password -d -e POSTGRES_DB=$1 postgres
}

3000() {
  [[ -n "$1" && ! "$1" =~ / ]] && http "$1" http://localhost:3000/$2 ${@:3} && return
  http http://localhost:3000$1 ${@:2}
}

kill_containers() {
  docker container rm -f $(docker container ls -qa)
}
b() {
  sudo systemctl restart bluetooth
}

docs() {
  apidoc -i $1 -o docs
}

ssh() {
  case "$1" in
    navi)
      /usr/bin/ssh mluna@lost-navi.xyz
      ;;
    *)
      /usr/bin/ssh $@
      ;;
  esac
}

pac() {
  sudo pacman "$@" || (echo "Trying with yay..." && yay "$@" || echo "Nope. Good luck.")
}

mkvm() {
  cp -r ~/.config/nvim $1
  cd $1
  rm -rf .git
  cd ..
}
# </Function>

# help :(

# <Env>
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
export JAVA_HOME=/usr/lib/jvm/default
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

export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:/$HOME/.emacs.d/bin"

# fix tmux bg bug
export TERM="xterm-256color"

neofetch() {
  # for some reason the ascii has some weird gaps. even weirder (or whatever the word is) is the fact that
  # it only happens *outside* vim's terminal :)
  gap=$([ -n "$VIMRUNTIME" ] || echo "--gap -73")
  eval "/opt/homebrew/bin/neofetch --ascii ~/.local/ascii/darkness2 --size 30% $gap | sed 's/\.local//'"
}

eval "$(direnv hook zsh)"
eval "$(zoxide init zsh)"

ok() {
git commit -m "$* 😑👍"
}

# load profile
source $HOME/.zprofile

# bun completions
[ -s "/home/mluna/.bun/_bun" ] && source "/home/mluna/.bun/_bun"

# Bun
export BUN_INSTALL="/home/mluna/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH="$HOME/.asdf/shims:$PATH"
