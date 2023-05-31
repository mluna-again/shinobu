return {
	"akinsho/bufferline.nvim",
	event = "User AlphaClosed",
	dependencies = "kanagawa.nvim",
	config = function()
		require("bufferline").setup({
			options = {
				-- offsets = { { filetype = "neo-tree", text = "" } },
				offsets = {},
				show_buffer_icons = false,
				show_close_icon = false,
				modified_icon = "",
				left_trunc_marker = "",
				right_trunc_marker = "",
				max_name_length = 14,
				max_prefix_length = 13,
				tab_size = 20,
				show_tab_indicators = true,
				enforce_regular_tabs = false,
				view = "multiwindow",
				show_buffer_close_icons = false,
				separator_style = "thin",
				always_show_bufferline = false,
				diagnostics = false,
			},
			highlights = {},
		})
	end,
}
