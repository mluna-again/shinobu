local ignored_fts = {
	"neo-tree",
	"dap",
	"diff"
}

return {
	"levouh/tint.nvim",
	event = "VeryLazy",
	config = function()
		require("tint").setup({
			tint = -60,
			window_ignore_function = function()
				for _, ft in pairs(ignored_fts) do
					if string.match(string.lower(vim.bo.filetype), ft) then
						return true
					end
				end

				return false
			end
		})

		vim.api.nvim_create_user_command("TintToggle", 'lua require("tint").toggle()', {})
	end
}
