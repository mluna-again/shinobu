return {
  "neanias/everforest-nvim",
  event = "VeryLazy",
  config = function()
    require("everforest").setup({
      ui_contrast = "high"
    })
  end,
}
