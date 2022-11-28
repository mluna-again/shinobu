return {
	'kyazdani42/nvim-web-devicons',
	config = function()
		require'nvim-web-devicons'.setup({
			override = {
				rb = {
					icon = "",
					color = "#a91401",
					name = "ruby"
				}
			}
		})
	end
}
