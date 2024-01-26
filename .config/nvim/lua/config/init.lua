vim.o.encoding = "UTF-8"
-- vim.o.clipboard = "unnamedplus"
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hidden = true
vim.o.background = "dark"
vim.o.mouse = "a"
vim.o.cursorline = false
vim.cmd([[
set expandtab
set tabstop=2
set shiftwidth=2
set statusline=
set showtabline=0
set splitright
set shm+=I " this removes welcome screen
set noshowmode
]])
vim.g.mapleader = " "
vim.opt.syntax = "on"
vim.api.nvim_command([[
au! FileType * setlocal formatoptions-=c formatoptions-=r formatoptions -=0
]])
vim.opt.colorcolumn = "99999"
vim.opt.cmdheight = 0

-- vim.api.nvim_command[[highlight Normal ctermbg=NONE guibg=NONE]]
vim.cmd([[highlight VertSplit cterm=NONE guibg=NONE]])
vim.cmd([[highlight EndOfBuffer guifg=bg]])
vim.cmd("colorscheme kanagawa-dragon")
vim.cmd("set laststatus=3")

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.hurl" },
	callback = function()
		vim.bo.filetype = "hurl"
	end,
})

-- Jump to last edit position on opening file
vim.cmd([[
  au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\""	| exe "normal zz" | endif
]])

-- LSP TWEAKS
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single", title = " Docs " })

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts = opts or {}
	opts.max_width = opts.max_width or 80
	return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

vim.api.nvim_create_user_command("Lsp", function()
	vim.cmd("Lazy load lsp-stuff")
	vim.cmd("Lazy load lsp_signature.nvim")
	vim.cmd("LspStart")
end, {})

-- php stuff :/
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.php" },
	callback = function()
		vim.bo.indentexpr = ""
		vim.bo.smartindent = true
		vim.bo.autoindent = true
	end
})
