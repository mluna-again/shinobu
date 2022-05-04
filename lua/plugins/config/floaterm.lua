vim.g.floaterm_keymap_toggle = "<A-m>"
vim.g.floaterm_title = ""
vim.g.floaterm_position = "top"
vim.g.floaterm_autoclose = 2
vim.g.floaterm_height = 0.8
vim.g.floaterm_width = 0.8
vim.g.floaterm_borderchars = "─│─│╭╮╯╰"
vim.api.nvim_command([[
autocmd User FloatermOpen hi FloatermBorder guibg=NONE guifg=#54546D
autocmd TermOpen * setlocal nonumber norelativenumber
]])

return {
	'voldikss/vim-floaterm'
}
