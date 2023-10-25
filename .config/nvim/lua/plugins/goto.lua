return {
	"rmagatti/goto-preview",
	event = "InsertEnter",
	config = function()
		require("goto-preview").setup({
			border = {"", "", "", "", "", "", "", ""}
		})
	end
}
