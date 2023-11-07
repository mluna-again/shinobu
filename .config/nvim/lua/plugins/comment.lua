return {
	"numToStr/Comment.nvim",
	event = "VeryLazy",
	config = function()
		require("Comment").setup()

		local ft = require("Comment.ft")

		ft.set("hurl", "#%s")
	end,
}
