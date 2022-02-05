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
