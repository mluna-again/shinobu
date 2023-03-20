require("core.maps")

return {
	'github/copilot.vim',
	config = function()
		vim.g.copilot_enabled = false
		vim.g.copilot_no_tab_map = true
		vim.g.copilot_filetypes = {
			text = false
		}
		imap("<C-J>", "copilot#Accept(\"<CR>\")", {silent = true, expr = true, script = true})
	end
}
