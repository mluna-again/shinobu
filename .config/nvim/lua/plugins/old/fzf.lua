return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	cmd = "FzfLua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- calling `setup` is optional for customization
		require("fzf-lua").setup({
			'default',
			global_color_icons = false,
			winopts = {
        height = 0.9,
        width = 0.9
			},
			fzf_opts = {
				['--color'] = 'bg:#282727,border:#282727,gutter:#282727,prompt:#c5c9c5',
				['--layout'] = 'default',
				['--header-first'] = '',
				['--cycle'] = '',
				['--no-scrollbar'] = '',
				['--no-separator'] = '',
				['--layout'] = 'reverse-list'
			}
		})
	end,
}
