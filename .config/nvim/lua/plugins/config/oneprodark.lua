return {
	'olimorris/onedarkpro.nvim',
	config = function ()
		local onedarkpro = require("onedarkpro")

		onedarkpro.setup({
			theme = "onedark_vivid"
		})

		onedarkpro.load()
	end
}
