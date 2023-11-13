return {
	"jackMort/ChatGPT.nvim",
	lazy = true,
	config = function()
		local home = vim.fn.expand("$HOME")
		require("chatgpt").setup({
			api_key_cmd = "gpg -d " .. home .. "/nvim_gpt.gpg",
		})
	end,
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
}
