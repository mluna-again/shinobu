return {
  "norcalli/nvim-colorizer.lua",
  config = function ()
    vim.cmd("set termguicolors")
    require'colorizer'.setup()
  end
}
