vim.o.encoding = "UTF-8"
vim.wo.number = true
vim.wo.relativenumber = true
vim.bo.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.laststatus = 2
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hidden = true
vim.o.background = "dark"
vim.o.mouse = "a"
vim.api.nvim_command([[
set nofoldenable
set foldmethod=syntax   
set foldnestmax=10
set foldlevel=2
set statusline=
set showtabline=0
]])
vim.g.mapleader = " "
vim.opt.syntax = "on"
vim.wo.t_Co = "256"
vim.api.nvim_command([[
au! FileType * setlocal formatoptions-=c formatoptions-=r formatoptions -=0
]])
vim.opt.colorcolumn = "99999"

-- COMMANDS
vim.cmd([[
silent! colorscheme kanagawa
command Ruby !ruby %
command Go !go run .
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
command Iex :FloatermNew --name=iex --autoclose=1 iex -S mix
command Irb :FloatermNew irb
command IRb :FloatermNew irb
command IRB :FloatermNew irb

autocmd! BufEnter *.rb nmap <silent> <C-p> :Ruby<CR>
autocmd! BufEnter *.lisp,*.cl nmap <silent> <C-p> :Lisp<CR>
autocmd! BufEnter *.cls nmap <silent> <C-p> :Clojure<CR>
autocmd! BufEnter *.js nmap <silent> <C-p> :Node<CR>
autocmd! BufEnter *.nim nmap <silent> <C-p> :Nim<CR>
autocmd! BufEnter *.ex,*.exs nmap <silent> <C-p> :Elixir<CR>
]])
-- vim.api.nvim_command[[highlight Normal ctermbg=NONE guibg=NONE]]
vim.cmd[[highlight VertSplit cterm=NONE guibg=NONE]]
vim.cmd[[highlight EndOfBuffer guifg=bg]]
