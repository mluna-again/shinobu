require("core.maps")

vim.cmd([[
let test#strategy = "neovim"
let test#neovim#term_position = "vert"
let g:test#neovim#start_normal = 1
]])

return {
	"vim-test/vim-test",
	event = "User AlphaClosed",
	config = function()
		nmap("<Leader>r", ":TestNearest<CR>")
		nmap("<Leader>R", ":TestFile<CR>")
		nmap("<Leader>T", ":TestSuite<CR>")
	end,
}
