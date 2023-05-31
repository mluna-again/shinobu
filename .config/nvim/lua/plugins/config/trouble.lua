return {
  "folke/trouble.nvim",
	event = "User AlphaClosed",
  config = function()
    require("trouble").setup {}
  end
}
