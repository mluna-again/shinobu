require('core.maps')

nmap("<C-Left>", ":vertical resize -2<CR>")
nmap("<C-Right>", ":vertial resize +2<CR>")
nmap("<C-Up>", ":resize +2<CR>")
nmap("<C-Down>", ":resize -2<CR>")
nmap("Y", "v$hy")
nmap("SS", ":w<CR>")
nmap("ss", ":noautocmd w<CR>")
nmap("gt", ":bn<CR>")
nmap("gr", ":bp<CR>")
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
nmap("<SPACE>", "<Nop>")

-- What do these do?
-- let g:mapleader="\<Space>"
-- nmap("tt", ":Bclose<CR>")
-- nmap <silent> <leader>r :TestNearest<CR>
-- nmap <silent> <leader>R :TestFile<CR>
-- nmap <silent> <leader>T :TestSuite<CR>
-- tnoremap <Esc> <C-\><C-n>

imap("jj", "<ESC>")
