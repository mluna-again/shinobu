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
		o = { ":only<CR>", "Close all but current window", noremap = true, silent = true },
		x = { "<C-w><C-r>", "Rotate window in current split", noremap = true, silent = true },
	},
	g = {
		name = "Git",
		d = {
			function()
				if next(require("diffview.lib").views) == nil then
					vim.cmd("DiffviewOpen")
				else
					vim.cmd("DiffviewClose")
				end
			end,
			"Toggle Diffview",
			noremap = true,
			silent = true,
		},
	},
}, { prefix = "<Leader>" })

-- vim-test
local wk = require("which-key")

wk.register({
	t = {
		r = {
			"<cmd>TestNearest<CR>",
			"Run test under cursor",
			silent = true,
			noremap = true,
		},
		R = {
			"<cmd>TestFile<CR>",
			"Run tests in current file",
			silent = true,
			noremap = true,
		},
		T = {
			"<cmd>TestSuite<CR>",
			"Run all tests in current project",
			silent = true,
			noremap = true,
		},
		name = "Testing",
	},
}, { prefix = "<Leader>" })

nmap("gr", ":tabprevious<CR>")
nmap("gt", ":tabnext<CR>")
nmap("<C-w><C-o>", ":wincmd r<CR>")
nmap("Y", "v$hy")
nmap("<C-Left>", ":vertical resize -2<CR>")
nmap("<C-Right>", ":vertical resize +2<CR>")
nmap("<C-Up>", ":resize +2<CR>")
nmap("<C-Down>", ":resize -2<CR>")
nmap("TT", ":only<CR>")
nmap("tt", ":Bdelete<CR>")
nmap("dh", ":noh<CR>")
nmap("Y", "y$")
nmap("''", "``")
nmap("!", ":ls<CR>")
nmap("-", "<C-e>")
nmap("¿", "<C-y>")
nmap("<Space>", "<Nop>")
nmap("/", ":lua require('telescope.builtin').current_buffer_fuzzy_find({prompt_title='Find in current file'})<CR>")
wk.register({
	f = {
		name = "Files and Directories",
		b = {
			"<cmd>lua require('telescope.builtin').buffers({ prompt_title = 'Buffers' })<CR>",
			"Search buffers",
			silent = true,
			noremap = true,
		},
		o = {
			"<cmd>lua require('telescope.builtin').oldfiles({prompt_title='History'})<CR>",
			"Search history",
			silent = true,
			noremap = true,
		},
		w = {
			"<cmd>lua require('telescope.builtin').live_grep({prompt_title='Search expression'})<CR>",
			"Search expresion",
			silent = true,
			noremap = true,
		},
		f = {
			"<cmd>Telescope find_files<CR>",
			"Search files",
			silent = true,
			noremap = true,
		},
		n = {
			function()
				-- if not MiniFiles.close() then
				-- 	MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
				-- end
				vim.cmd("Oil")
			end,
			"Open file explorer",
			silent = true,
			noremap = true,
		},
	},
}, { prefix = "<leader>" })

nmap("<Leader>cn", ":enew<CR>")

vim.cmd("command -nargs=* Figlet :read!figlet -w 80 -f larry3d <args>")
vim.cmd("command Empty :%bd|e#|bd#")
