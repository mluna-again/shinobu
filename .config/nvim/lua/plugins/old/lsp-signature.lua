return {
	"ray-x/lsp_signature.nvim",
	cmd = "Lsp",
	config = function()
		require("lsp_signature").setup({
			hint_prefix = " ",
			hint_enable = true
		})
	end
}
