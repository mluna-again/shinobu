return {
	"folke/trouble.nvim",
	event = "InsertEnter",
	config = function()
		require("trouble").setup({
			icons = false,
			action_keys = {
				open_split = { "<c-s>" },
				open_vsplit = { "<c-v>" },
			},
			auto_preview = false
		})
	end,
}
