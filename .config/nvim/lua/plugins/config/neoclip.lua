return {
  "AckslD/nvim-neoclip.lua",
	requires = {
    {'nvim-telescope/telescope.nvim'},
  },
  config = function()
		require('telescope').load_extension('neoclip')
    require('neoclip').setup()
  end
}
