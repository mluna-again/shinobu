require('core.maps')

nmap("<C-Left>", ":vertical resize -2<CR>")
nmap("<C-Right>", ":vertical resize +2<CR>")
nmap("<C-Up>", ":resize +2<CR>")
nmap("<C-Down>", ":resize -2<CR>")
nmap("Y", "v$hy")
nmap("SS", ":w<CR>")
nmap("ss", ":noautocmd w<CR>")
nmap("gt", ":BufferLineCycleNext<CR>")
nmap("gr", ":BufferLineCyclePrev<CR>")
nmap("gT", ":BufferLineMoveNext<CR>")
nmap("gR", ":BufferLineMovePrev<CR>")
nmap("TT", ":only<CR>")
nmap("tt", ":Bdelete<CR>")
nmap("dh", ":noh<CR>")
nmap("''", "``")
nmap("!", ":ls<CR>")
nmap("<A-k>", ":wincmd k<CR>")
nmap("<A-j>", ":wincmd j<CR>")
nmap("<A-h>", ":wincmd h<CR>")
nmap("<A-l>", ":wincmd l<CR>")
nmap("-", "<C-e>")
nmap("¿", "<C-y>")
nmap("{", "<C-u>")
nmap("}", "<C-d>")
nmap("<C-f>", ":call CocAction('jumpDefinition', 'drop')<CR>")
nmap("<C-x>", ":bufdo bd | :Dashboard<CR>")
nmap("<Space>", "<Nop>")
nmap("<Leader>fn", ":NvimTreeFindFile<CR>")
nmap("FF", ":NvimTreeToggle<CR>")
nmap("ff", ":DashboardFindFile<CR>")
nmap("ñ", ":Commentary<CR>")
nmap("/", ":Telescope current_buffer_fuzzy_find<CR>")
vim.cmd([[
vnoremap ñ :Commentary<CR>
]])

imap("jj", "<ESC>")
