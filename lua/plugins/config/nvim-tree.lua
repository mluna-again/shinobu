vim.g.nvim_tree_side = "right"

return {
  'kyazdani42/nvim-tree.lua',
  config = function()
    require("nvim-tree").setup{
      auto_close = true,
      update_cwd = true,
      view = {
        side = "left",
        width = "20%"
      },
    }
  end
}
