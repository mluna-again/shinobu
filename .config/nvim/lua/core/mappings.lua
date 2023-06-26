local wk = require("which-key")

wk.register({
	w = {
		name = "Window management",
		k = { ":wincmd k<CR>", "Down", noremap = true, silent = true },
		j = { ":wincmd j<CR>", "Up", noremap = true, silent = true },
		h = { ":wincmd h<CR>", "Left", noremap = true, silent = true },
		l = { ":wincmd l<CR>", "Right", noremap = true, silent = true },
		w = { "<C-w><C-w>", "Next", noremap = true, silent = true },
		s = { "<C-w>s", "Open vertical window", noremap = true, silent = true },
		v = { "<C-w>v", "Open horizontal window", noremap = true, silent = true },
		d = { "<C-w>q", "Close window", noremap = true, silent = true },
		q = { "<C-w>q", "Also close window", noremap = true, silent = true },
	}
}, { prefix = "<Leader>" })

wk.register({
	s = {
		s = { ":w<CR>", "Save buffer", noremap = true, silent = true },
	},
	S = {
		S = { ":noautocmd w<CR>", "Save buffer without autocmds", noremap = true, silent = true }
	},
	g = {
		name = "Buffer navigation",
		t = { ":BufferLineCycleNext<CR>", "Next", noremap = true, silent = true },
		r = { ":BufferLineCyclePrev<CR>", "Prev", noremap = true, silent = true },
		T = { ":BufferLineMoveNext<CR>", "Move to right", noremap = true, silent = true },
		R = { ":BufferLineMoveNext<CR>", "Move to left", noremap = true, silent = true },
	}
})

nmap("Y", "v$hy")
nmap("<C-Left>", ":vertical resize -2<CR>")
nmap("<C-Right>", ":vertical resize +2<CR>")
nmap("<C-Up>", ":resize +2<CR>")
nmap("<C-Down>", ":resize -2<CR>")
nmap("<Leader>fd", ":Telescope buffers<CR>")
nmap("TT", ":only<CR>")
nmap("tt", ":Bdelete<CR>")
nmap("dh", ":noh<CR>")
nmap("Y", "y$")
nmap("''", "``")
nmap("!", ":ls<CR>")
nmap("-", "<C-e>")
nmap("¿", "<C-y>")
imap("jj", "<ESC>")
nmap("<Space>", "<Nop>")
nmap("/", ":lua require('telescope.builtin').current_buffer_fuzzy_find({prompt_title='Find in current file'})<CR>")
nmap("<Leader>sl", ":source Session.vim<CR>")
nmap("<Leader>ss", ":Obsession<CR>")
nmap("<Leader>fo", ":lua require('telescope.builtin').oldfiles({prompt_title='History'})<CR>")
nmap("<Leader>fw", ":lua require('telescope.builtin').live_grep({prompt_title='Search expression'})<CR>")
nmap("<Leader>ff", ":Telescope find_files<CR>")
nmap("<Leader>cn", ":enew<CR>")
nmap("<Leader>fn", ":Oil --float<CR>")

-- nmap("<Leader>dd", ":DiffviewOpen<CR>")
-- nmap("<Leader>D", ":DiffviewClose<CR>")
vim.cmd("command Close :bufdo bd | Dashboard")
vim.cmd("command -nargs=* Figlet :read!figlet -w 80 -f larry3d <args>")
vim.cmd("command Preload :doautocmd User AlphaClosed | LspStart")
