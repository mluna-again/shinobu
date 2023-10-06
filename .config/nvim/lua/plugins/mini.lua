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
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "dbout" },
			callback = function (data)
				vim.b[data.buf].minitrailspace_disable = true
				vim.api.nvim_buf_call(data.buf, MiniTrailspace.unhighlight)
			end
		})
	end
}
