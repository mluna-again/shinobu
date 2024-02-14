<h1 align="center">shinobu 🐥</h1>
<img width="1440" alt="Screenshot 2023-08-30 at 1 33 06 p m" src="https://github.com/mluna-again/shinobu/assets/53100040/12753432-7ffd-49d9-acd2-2da8d0e6c499">
<img width="1440" alt="Screenshot 2023-08-06 at 2 17 00 a m" src="https://github.com/mluna-again/shinobu/assets/53100040/ceaec878-59b8-4374-97e7-fcec73015f0b">
<img width="1440" alt="Screenshot 2023-08-06 at 2 17 54 a m" src="https://github.com/mluna-again/shinobu/assets/53100040/acfce932-8da7-4b1f-b687-3577a2aebf61">
<img width="1440" alt="Screenshot 2023-08-06 at 2 18 29 a m" src="https://github.com/mluna-again/shinobu/assets/53100040/57d64364-db4d-4d16-8a6c-77420b9b004d">
<img width="1440" alt="Screenshot 2023-10-20 at 3 14 45 p m" src="https://github.com/mluna-again/shinobu/assets/53100040/487e33a8-6411-4b5c-9165-53dba573abcb">

https://github.com/mluna-again/shinobu/assets/53100040/9a53fa5a-ccb0-42a8-a283-6cedb5a494d6

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
