local function yankFullBufferPath()
	vim.cmd("let @+ = expand(\"%:p\")")
end

local function yankBufferPath()
	vim.cmd("let @+ = expand(\"%\")")
end

vim.api.nvim_create_user_command("YankF", yankFullBufferPath, {})
vim.api.nvim_create_user_command("YankP", yankBufferPath, {})
