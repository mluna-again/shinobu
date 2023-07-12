<h1 align="center">shinobu 🍙</h1>

<img width="1920" target="_blank" alt="shinobu showcase" src="https://raw.githubusercontent.com/mluna-again/shinobu/master/.github/previews/shinobu.png">
<img width="1920" target="_blank" alt="telescope" src="https://raw.githubusercontent.com/mluna-again/shinobu/master/.github/previews/telescope.png">
<img width="1920" target="_blank" alt="code" src="https://raw.githubusercontent.com/mluna-again/shinobu/master/.github/previews/code.png">
<img width="1920" target="_blank" alt="neotest" src="https://raw.githubusercontent.com/mluna-again/shinobu/master/.github/previews/neotest.png">
<img width="1920" target="_blank" alt="noice" src="https://raw.githubusercontent.com/mluna-again/shinobu/master/.github/previews/noice.png">
<img width="1920" target="_blank" alt="dap" src="https://raw.githubusercontent.com/mluna-again/shinobu/master/.github/previews/dap.png">
<img width="1920" target="_blank" alt="tmux-sessions" src="https://raw.githubusercontent.com/mluna-again/shinobu/master/.github/previews/tmux-switcher.png">
<img width="1920" target="_blank" alt="monitor" src="https://raw.githubusercontent.com/mluna-again/shinobu/master/.github/previews/monitor.png">

## Dependencies
### Required
1. nvim
2. tmux
3. zsh
4. yadm
5. starship
6. git
7. make

### Recommended
1. fd
2. ripgrep
3. zoxide
4. fzf
5. go
6. spotify-player
7. spotify (desktop)
8. shpotify
9. hurl
10. jq
11. jqp
12. httpie
13. exa
14. delta
15. direnv
16. watchexec
17. bat

## Problems I've encountered that I don't want to forget

* You open a file and no status line and/or highlight on:

    - Install the corresponding lsp for that language (:MasonInstall \<lsp-name\>)

* OSX key-repeat is too slow:
    - defaults write -g InitialKeyRepeat -int 15
    - defaults write -g KeyRepeat -int 1
    - logout
