return {
	"stevearc/oil.nvim",
	opts = {},
	dependencies = {
		"kyazdani42/nvim-web-devicons",
	},
	config = function()
		require("oil").setup()
	end
}
