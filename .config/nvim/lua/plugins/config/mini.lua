return {
	"echasnovski/mini.nvim",
	version = false,
	event = "VeryLazy",
	config = function ()
		require("mini.trailspace").setup()
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = { "*" },
			callback = function (_)
				MiniTrailspace.trim()
			end
		})
	end
}
