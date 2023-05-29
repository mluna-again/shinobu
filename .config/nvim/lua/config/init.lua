vim.o.encoding = "UTF-8"
-- vim.o.clipboard = "unnamedplus"
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hidden = true
vim.o.background = "dark"
vim.o.mouse = "a"
vim.o.cursorline = false
vim.cmd([[
set expandtab
set tabstop=2
set shiftwidth=2
set statusline=
set showtabline=0
set splitright
set shm+=I " this removes welcome screen
set noshowmode
]])
vim.g.mapleader = " "
vim.opt.syntax = "on"
vim.api.nvim_command([[
au! FileType * setlocal formatoptions-=c formatoptions-=r formatoptions -=0
]])
vim.opt.colorcolumn = "99999"

-- vim.api.nvim_command[[highlight Normal ctermbg=NONE guibg=NONE]]
vim.cmd[[highlight VertSplit cterm=NONE guibg=NONE]]
vim.cmd[[highlight EndOfBuffer guifg=bg]]
vim.cmd("colorscheme kanagawa-dragon")
vim.cmd("set laststatus=3")
