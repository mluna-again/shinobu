return {
	"williamboman/mason.nvim",
	-- cmd = {
	-- 	"Mason",
	-- 	"MasonInstall",
	-- 	"MasonInstallAll",
	-- 	"MasonLog",
	-- 	"MasonUninstall",
	-- 	"MasonUninstallAll",
	-- 	"MasonUpdate",
	-- },
	config = function()
		local mason = require("mason")

		local basic_packages = {
			"elixir-ls",
			"goimports",
			"golangci-lint-langserver",
			"golangci-lint",
			"gomodifytags",
			"gopls",
			"stylua",
			"prettier",
			"typescript-language-server",
			"css-lsp",
			"shellcheck",
			"solargraph",
			"rust-analyzer",
			"tailwindcss-language-server",
			"bash-language-server",
			"sqlfluff",
			"zls"
		}

		mason.setup({
			max_concurrent_installers = 10,
		})

		vim.api.nvim_create_user_command("MasonInstallAll", function()
			vim.cmd("MasonInstall " .. table.concat(basic_packages, " "))
		end, {})
	end,
}
