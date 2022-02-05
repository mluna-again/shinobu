require('core.maps')

nmap("<C-Left>", ":vertical resize -2<CR>")
nmap("<C-Right>", ":vertial resize +2<CR>")
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
nmap("dh", ":noh<CR>")
nmap("''", "``")
nmap("!", ":ls<CR>")
nmap("<A-k>", ":wincmd k<CR>")
nmap("<A-j>", ":wincmd j<CR>")
nmap("<A-h>", ":wincmd h<CR>")
nmap("<A-l>", ":wincmd l<CR>")
nmap("-", "<C-e>")
nmap("¿", "<C-y>")
nmap("ñ", "<Plug>Commentary")
nmap("{", "<C-b>")
nmap("}", "<C-d>")
nmap("<C-f>", ":call CocAction('jumpDefinition', 'drop')<CR>")
nmap("<C-x>", ":bufdo bd | :Dashboard<CR>")
nmap("<Space>", "<Nop>")
nmap("<Leader>fn", ":NvimTreeFindFile<CR>")
nmap("FF", ":NvimTreeToggle<CR>")
nmap("ff", ":DashboardFindFile<CR>")

-- nmap("<Leader>ss", ":<C-u>SessionSave<CR>")
nmap("<Leader>sl", ":<C-u>SessionLoad<CR>")
nmap("<Leader>fh", ":DashboardFindHistory<CR>")
nmap("<Leader>ff", ":DashboardFindFile<CR>")
-- nmap("<Leader>tc", ":DashboardChangeColorscheme<CR>")
nmap("<Leader>fa", ":DashboardFindWord<CR>")
-- nmap("<Leader>fb", ":DashboardJumpMark<CR>")
nmap("<Leader>cn", ":DashboardNewFile<CR>")

-- What do these do?
-- let g:mapleader="\<Space>"
-- nmap("tt", ":Bclose<CR>")
-- nmap <silent> <leader>r :TestNearest<CR>
-- nmap <silent> <leader>R :TestFile<CR>
-- nmap <silent> <leader>T :TestSuite<CR>
-- tnoremap <Esc> <C-\><C-n>

imap("jj", "<ESC>")
