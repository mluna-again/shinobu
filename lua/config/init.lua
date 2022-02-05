vim.o.encoding = "UTF-8"
vim.wo.number = true
vim.wo.relativenumber = true
vim.bo.expandtab = true
vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.o.showtabline = 2
vim.o.laststatus = 2
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hidden = true
vim.o.background = "dark"
vim.o.mouse = "a"
vim.g.mapleader = " "
vim.opt.syntax = "on"
vim.cmd("colorscheme gruvbox")
vim.wo.t_Co = "256"
vim.api.nvim_command[[highlight Normal ctermbg=NONE guibg=NONE]]
vim.api.nvim_command[[highlight VertSplit cterm=NONE guibg=NONE]]
vim.api.nvim_command[[set fillchars+=vert:\ ]]
vim.api.nvim_command([[
au! FileType * setlocal formatoptions-=c formatoptions-=r formatoptions -=0
]])
vim.g.indentLine_fileTypeExclude = {'dashboard', 'dockerfile', 'json'}
vim.opt.colorcolumn = "99999"

-- COMMANDS
vim.cmd([[
command Ruby !ruby %
command Lisp !sbcl --script %
command Clojure !clj -M %
command Node !node %
command Python !python %
command Nim !nim c -r %
command Elixir !elixir %
command Env :e .env
command T :call ToggleFormatter()
command C normal ggVG"+y
command IEx :FloatermNew --name=iex --autoclose=1 iex -S mix
command IRB :FloatermNew irb

autocmd! BufEnter *.rb nmap <silent> <C-p> :Ruby<CR>
autocmd! BufEnter *.lisp,*.cl nmap <silent> <C-p> :Lisp<CR>
autocmd! BufEnter *.cls nmap <silent> <C-p> :Clojure<CR>
autocmd! BufEnter *.js nmap <silent> <C-p> :Node<CR>
autocmd! BufEnter *.nim nmap <silent> <C-p> :Nim<CR>
autocmd! BufEnter *.ex,*.exs nmap <silent> <C-p> :Elixir<CR>
]])
