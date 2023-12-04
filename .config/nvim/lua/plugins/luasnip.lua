return {
	"L3MON4D3/LuaSnip",
	lazy = true,
	version = "v2.*",
	build = "make install_jsregexp",
	config = function()
		local ls = require("luasnip")
		require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets" })
		ls.filetype_extend("fish", { "sh" })
		vim.keymap.set({"i", "s"}, "<C-l>", function() ls.jump( 1) end, {silent = true})
	end
}
