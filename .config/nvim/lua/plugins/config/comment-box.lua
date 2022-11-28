require("core.maps")

return {
	"LudoPinelli/comment-box.nvim",
	config = function ()
		local keymap = vim.api.nvim_set_keymap
		keymap("n", "<Leader>bc", "<Cmd>lua require('comment-box').cbox()<CR>", {})
		keymap("v", "<Leader>bc", "<Cmd>lua require('comment-box').cbox()<CR>", {})
	end
}
