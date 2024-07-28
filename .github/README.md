<h1 align="center">shinobu 🐥</h1>

https://github.com/mluna-again/shinobu/assets/53100040/e04eb9fa-41aa-4320-ab12-825a7b0d7ebf


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
15. entr
16. bat
17. r*st
18. yq
19. sc-im
20. atuin
21. pgcli
22. json-server
23. presenterm
24. sqlfluff
25. the_silver_searcher
26. glow

# Linux (sway)
1. sway
2. bemenu
3. swaybg
4. grim
5. wl-clipboard (grim dep)
6. slurp (grim dep)
7. jq (grim dep)
8. notify-send (grim dep, you probably already have this)
9. swayidle
10. swaylock-effects
11. ly

## Problems I've encountered that I don't want to forget

* You open a file and no status line and/or highlight on:

    - Install the corresponding lsp for that language (:MasonInstall \<lsp-name\>)

* OSX key-repeat is too slow:
    - defaults write -g InitialKeyRepeat -int 15
    - defaults write -g KeyRepeat -int 1
    - logout

## Post-installation

* Compile go scripts:
```sh
$ _install
```

* Enable shutdown without password prompt:
```sh
$ sudo visudo
# add the following line: <username> ALL=(ALL) NOPASSWD: /sbin/poweroff, /sbin/reboot, /sbin/shutdown
# replace <username> with your username 😑
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
## Post-installation (linux sway only)

* Copy ty config files
```sh
$ cp .config/ty/config.ini /etc/ly/config.ini # probably needs sudo
```
