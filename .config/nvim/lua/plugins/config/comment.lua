return {
  "numToStr/Comment.nvim",
	event = "User AlphaClosed",
  config = function ()
    require("Comment").setup()
  end
}
