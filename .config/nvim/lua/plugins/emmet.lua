vim.g.user_emmet_leader_key = "<C-k>"

return {
	"mattn/emmet-vim",
	event = "VeryLazy",
	ft = { "html", "javascript", "typescript", "javascriptreact", "typescriptreact" },
}
