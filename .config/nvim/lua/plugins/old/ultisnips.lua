vim.g.UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit = "~/.config/nvim/ultisnips"
vim.g.UltiSnipsSnippetsDir = "~/.config/nvim/"
vim.g.UltiSnipsSnippetDirectories = { "ultisnips" }
vim.g.UltiSnipsExpandTrigger = "<C-l>"
vim.g.UltiSnipsJumpForwardTrigger = "<C-l>"
vim.g.UltiSnipsJumpBackwardTrigger = "<nop>"
return {
	"SirVer/ultisnips",
	lazy = true,
	init = function()
		vim.cmd([[
		if exists("$VIRTUAL_ENV")
			let g:python3_host_prog=substitute(system("which -a python3 | head -n2 | tail -n1"), "\n", '', 'g')
		else
			let g:python3_host_prog=substitute(system("which python3"), "\n", '', 'g')
		endif
		]])
	end
}
