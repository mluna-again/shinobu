<h1 align="center">shinobu 🐥</h1>

https://github.com/mluna-again/shinobu/assets/53100040/6fbde91e-3ffd-4689-b2c9-44cf161c714a

## Dependencies
### Required
1. nvim (0.9+)
2. tmux (3.3a+)
3. fish
4. yadm
5. starship
6. git
7. make
8. zoxide
9. direnv (2.32+)
10. jq

### Recommended
1. fd
2. ripgrep
3. fzf
4. go
5. spotify-player
6. spotify (desktop)
7. shpotify
8. hurl
9. tmuxp
10. jqp
11. httpie
12. eza
13. delta
14. direnv
15. watchexec
16. bat
17. r*st
18. yq
19. sc-im
20. atuin
21. pgcli
22. json-server
23. presenterm
24. pg_format

## Problems I've encountered that I don't want to forget

* You open a file and no status line and/or highlight on:

    - Install the corresponding lsp for that language (:MasonInstall \<lsp-name\>)

* OSX key-repeat is too slow:
    - defaults write -g InitialKeyRepeat -int 15
    - defaults write -g KeyRepeat -int 1
    - logout

## Post-installation

* Compile shift:
```sh
$ cd ~/.local/scripts/shift
$ go build
```

* Install tmp:
```sh
$ git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Ctrl-I inside tmux
```

* Enable bat kanagawa theme:
```sh
$ bat cache --build
```
