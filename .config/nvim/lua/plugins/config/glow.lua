return {
  "ellisonleao/glow.nvim",
	event = "User AlphaClosed",
  config = function()
    require("glow").setup({
      width_ratio = 1.0,
      height_ratio = 1.0,
      border = "none"
    })
  end
}
