return {
	'kyazdani42/nvim-web-devicons',
	config = function()
		require'nvim-web-devicons'.setup({
			override = {
				cshtml = {
					icon = "",
					color = "#953dab",
					name = "razor"
				},
				rb = {
					icon = "",
					color = "#a91401",
					name = "ruby"
				},
				go = {
					icon = "",
					color = "#86D4DE",
					name = "go"
				}
			}
		})
	end
}
