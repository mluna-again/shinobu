<h1 align="center">shinobu 🍙</h1>

# neovim
<img width="1920" target="_blank" alt="shinobu showcase" src="https://raw.githubusercontent.com/mluna-again/shinobu/master/.github/previews/shinobu.png">
<img width="1920" target="_blank" alt="telescope" src="https://raw.githubusercontent.com/mluna-again/shinobu/master/.github/previews/telescope.png">
<img width="1920" target="_blank" alt="code" src="https://raw.githubusercontent.com/mluna-again/shinobu/master/.github/previews/code.png">
<img width="1920" target="_blank" alt="neotest" src="https://raw.githubusercontent.com/mluna-again/shinobu/master/.github/previews/neotest.png">
<img width="1920" target="_blank" alt="noice" src="https://raw.githubusercontent.com/mluna-again/shinobu/master/.github/previews/noice.png">
<img width="1920" target="_blank" alt="dap" src="https://raw.githubusercontent.com/mluna-again/shinobu/master/.github/previews/dap.png">
<img width="1920" target="_blank" alt="spotify" src="https://raw.githubusercontent.com/mluna-again/shinobu/master/.github/previews/spotify.png">

## Problems I've encountered that I don't want to forget

* You open a file and no status line and/or highlight on:

    - Install the corresponding lsp for that language (:MasonInstall \<lsp-name\>)

* :Neorg sync-parsers throws an error:

    - Install a recent c++ compiler with `brew install gcc`
    - Get c++ compiler path with `brew info gcc`
    - Export the `CC` env variable as `export CC=<gcc path>`
