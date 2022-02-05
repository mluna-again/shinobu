return {
  'akinsho/nvim-bufferline.lua',
  config = function()
    require("bufferline").setup{
      options = {
        show_buffer_close_icons = false,
        show_close_icon = false,
      }
    }
  end
}
