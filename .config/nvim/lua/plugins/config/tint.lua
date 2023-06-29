return {
	"levouh/tint.nvim",
	event = "VeryLazy",
	config = function()
		require("tint").setup({
			tint = -60,
			window_ignore_function = function()
				if vim.bo.filetype == "neo-tree" then
					return true
				end

				if string.match(vim.bo.filetype, "dap") then
					return true
				end

				return false
			end
		})
	end
}
