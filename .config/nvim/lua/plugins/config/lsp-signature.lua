return {
	"ray-x/lsp_signature.nvim",
	event = "User AlphaClosed",
	config = function()
		require("lsp_signature").setup({
			hint_prefix = " ",
			hint_enable = false
		})
	end
}
