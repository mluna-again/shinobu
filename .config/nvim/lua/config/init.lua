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
vim.opt.previewheight = 20
vim.opt.spelloptions = "camel"

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

vim.opt.undofile = true

-- LSP TWEAKS
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single", title = " Docs " })

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts = opts or {}
	opts.max_width = opts.max_width or 80
	return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- FILETYPE ALIASES
vim.filetype.add({ extension = {
	heex = "html",
} })

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = " ",
			[vim.diagnostic.severity.INFO] = "",
		},
		linehl = {
			[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
			[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
			[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
			[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
		},
	},
})

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
	end,
})

if vim.g.neovide then
	-- vim.cmd("set guicursor=n-v-c-i:block-blinkwait275-blinkoff250-blinkon400")
	-- vim.g.neovide_cursor_smooth_blink = true
	vim.g.neovide_cursor_vfx_mode = "ripple"
	vim.cmd("cd")
end
