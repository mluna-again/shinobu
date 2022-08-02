#! /bin/sh

set -e

_install_brew() {
  command -v brew &>/dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

_install_gum() {
  command -v gum &>/dev/null || brew install gum
}

_setup() {
  _install_brew
  _install_gum
}

_setup

answer=$(gum input --prompt "This will take a while. Proceed? " --placeholder "[y/yes/N]" | tr '[:upper:]' '[:lower:]')

_loader() {
  title="$1"
  shift
  gum spin -s jump --title "$title" -- $@
}

_done() {
  echo "✅ $1"
}

_install() {
  command -v $([ -z $2 ] && echo $1 || echo $2) &>/dev/null || _loader "Installing $1" brew install "$1" \
  && _done "$1 installed" \
  || brew install $1 # show me what went wrong
}

_main() {
  _install neovim nvim
  _install git
  _install fzf
  _install ripgrep rg
  _install zsh
  _install starship
  _install exa
  _install bat
  _install tmux
  _install direnv
  _install zoxide
  _install jq
  _install gcc
  _install chafa
  _install unzip
  _install asdf
}

case $answer in
  y|yes)
    _main
    ;;
  *) 
    echo "Aborting..."
    ;;
esac
