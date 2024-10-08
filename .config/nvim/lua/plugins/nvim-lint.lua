return {
	"mfussenegger/nvim-lint",
	event = {
		"BufWritePost"
	},
	config = function()
		require("lint").linters_by_ft = {
			sh = {
				"shellcheck"
			},
			sql = {
				"sqlfluff"
			},
			python = {
				"flake8"
			}
		}

		require("lint").try_lint()
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
