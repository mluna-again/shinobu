return {
	"levouh/tint.nvim",
	event = "User AlphaClosed",
	config = function()
		require("tint").setup({
			tint = -60
		})
	end
}
