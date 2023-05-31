function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function imap(lhs, rhs, opts)
	map("i", lhs, rhs, opts)
end

function nmap(lhs, rhs, opts)
	map("n", lhs, rhs, opts)
end

function vmap(lhs, rhs, opts)
	map("v", lhs, rhs, opts)
end

function tmap(lhs, rhs, opts)
	map("t", lhs, rhs, opts)
end
