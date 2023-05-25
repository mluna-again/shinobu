<h1 align="center">shinobu 🍙</h1>

# neovim
<img width="1920" target="_blank" alt="shinobu showcase" src="https://raw.githubusercontent.com/mluna-again/shinobu/master/.github/previews/shinobu.png">
<img width="1920" target="_blank" alt="telescope" src="https://raw.githubusercontent.com/mluna-again/shinobu/master/.github/previews/telescope.png">
<img width="1920" target="_blank" alt="neofetch" src="https://raw.githubusercontent.com/mluna-again/shinobu/master/.github/previews/code.png">
<img width="1920" target="_blank" alt="neofetch" src="https://raw.githubusercontent.com/mluna-again/shinobu/master/.github/previews/terminal.png">

# emacs
https://user-images.githubusercontent.com/53100040/205425911-e24e7d5f-c72b-419c-98b4-e189dc1fb66a.mp4

## Problems I've encountered that I don't want to forget

* You open a file and no status line and/or highlight on:

    - Install the corresponding lsp for that language (:MasonInstall \<lsp-name\>)

* :Neorg sync-parsers throws an error:

    - Install a recent c++ compiler with `brew install gcc`
    - Get c++ compiler path with `brew info gcc`
    - Export the `CC` env variable as `export CC=<gcc path>`
