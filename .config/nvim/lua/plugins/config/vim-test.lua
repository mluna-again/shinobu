require('core.maps')

vim.cmd([[
let test#strategy = "neovim"
let test#neovim#term_position = "vert"
]])

return {
	'vim-test/vim-test',
	config = function()
		nmap("<Leader>r", ":TestNearest<CR>")
		nmap("<Leader>R", ":TestFile<CR>")
		nmap("<Leader>T", ":TestSuite<CR>")
	end
}
