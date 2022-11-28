vim.o.encoding = "UTF-8"
-- vim.o.clipboard = "unnamedplus"
vim.wo.number = true
vim.wo.relativenumber = true
vim.bo.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.laststatus = 3
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
set splitright
set shm+=I " this removes welcome screen
]])
vim.g.mapleader = " "
vim.opt.syntax = "on"
vim.api.nvim_command([[
au! FileType * setlocal formatoptions-=c formatoptions-=r formatoptions -=0
]])
vim.opt.colorcolumn = "99999"

-- COMMANDS
vim.cmd([[
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
]])
-- vim.api.nvim_command[[highlight Normal ctermbg=NONE guibg=NONE]]
vim.cmd[[highlight VertSplit cterm=NONE guibg=NONE]]
vim.cmd[[highlight EndOfBuffer guifg=bg]]

-- neovide
vim.cmd[[
if exists("g:neovide")
	let g:neovide_transparency=0.9
	let g:neovide_floating_blur_amount_y=2.0
	let g:neovide_floating_blur_amount_x=2.0
	let g:neovide_input_use_logo=v:true
	let g:neovide_cursor_trail_size=0.8
	let g:neovide_cursor_vfx_mode="ripple"
endif
]]
