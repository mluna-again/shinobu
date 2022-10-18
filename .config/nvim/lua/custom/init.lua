vim.cmd("set relativenumber")
vim.cmd("command Close :bufdo bd | Alpha")
vim.cmd("command CLose :bufdo bd | Alpha")
vim.cmd("command CLOse :bufdo bd | Alpha")
-- vim.cmd([[
--   set foldmethod=expr
--   set foldexpr=nvim_treesitter#foldexpr()
--   set foldtext=substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend))
--   set fillchars=fold:\\
--   set foldnestmax=3
--   set foldminlines=1
--   autocmd! BufEnter * normal zR
--   command! Fold :e | normal zMzr
--   command! Unfold normal zR
-- ]])

vim.g.loaded_matchit = nil
