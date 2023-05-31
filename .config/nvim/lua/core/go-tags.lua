local function _byte_offset()
	local row = vim.api.nvim_win_get_cursor(0)[1]
	return vim.fn.line2byte(row)
end

local function _is_go_file()
	return vim.bo.filetype == "go"
end

local function _go_add_tags()
	if not _is_go_file() then
		print("Not a go file")
		return
	end

	local offset = _byte_offset()
	local path = vim.api.nvim_buf_get_name(0)
	local command = string.format("gomodifytags -file %s -offset %d -add-tags json -w --quiet", path, offset)

	vim.fn.system(command)
	vim.cmd("e")
end

vim.api.nvim_create_user_command("GoAddTags", function()
	_go_add_tags()
end, {})
