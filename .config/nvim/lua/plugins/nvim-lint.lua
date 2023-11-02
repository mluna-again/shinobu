return {
	"mfussenegger/nvim-lint",
	event = "InsertEnter",
	config = function()
		require("lint").linters_by_ft = {
			sh = {
				"shellcheck"
			},
			sql = {
				"sqlfluff"
			}
		}

		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})

		vim.api.nvim_create_autocmd({ "BufEnter" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})
	end
}
