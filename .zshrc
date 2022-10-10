# git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
[ -e ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
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
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'
plugins=(vi-mode)
autoload -Uz compinit
compinit
MANPATH="$NPM_PACKAGES/share/man:$MANPATH"
# </Config>

# utils
alias q="exit"
alias cd="z"
alias :q="exit"
alias ls="exa --icons"
alias rice='curl -L rum.sh/ricebowl'
alias rice='curl -L git.io/rice'
alias darkness="cat -p ~/.config/nvim/banners/darkness"
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
alias dotsA="dots add -u"
alias dotsl="dots log"
alias dotsC="dots checkout"
alias dotsR="dots reset --hard"
alias dotsp="dots push"
alias dotsP="dots pull"
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
t() {
  tmuxinator start && return || clear && tmux
}
# </Function>

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

eval "$(direnv hook zsh)"
eval "$(zoxide init zsh)"

ok() {
git commit -m "$* 😑👍"
}

# load profile
[ -e $HOME/.zprofile ] && source $HOME/.zprofile

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

[ -e $HOME/.asdf/asdf.sh ] && . $HOME/.asdf/asdf.sh

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

command -v rbenv &>/dev/null && eval "$(rbenv init -)" || true

[ -e ~/.personal ] && source ~/.personal || true
