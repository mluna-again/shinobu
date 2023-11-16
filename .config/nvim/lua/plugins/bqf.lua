return {
	"kevinhwang91/nvim-bqf",
	ft = "qf",
	config = function()
		require("bqf").setup({
			preview = {
				winblend = 0,
				border = {'┏', '━', '┓', '┃', '┛', '━', '┗', '┃'},
			}
		})
	end
}
