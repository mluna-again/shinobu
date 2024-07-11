local function yankFullBufferPath()
	local path = vim.fn.expand("%:p")
	local short_path = path:gsub(os.getenv("HOME"), "~")
	local cmd = string.format("let @+ = \"%s\"", short_path)

	vim.cmd(cmd)
end

vim.api.nvim_create_user_command("YankBufferPath", yankFullBufferPath, {})
