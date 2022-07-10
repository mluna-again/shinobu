vim.g.minimap_width = 20
vim.g.minimap_auto_start_win_enter = 1
vim.g.minimap_block_filetypes = {'fugitive', 'nerdtree', 'tagbar', 'fzf', 'dashboard', 'terminal'}
vim.g.minimap_block_buftypes = {'nofile', 'nowrite', 'quickfix', 'terminal', 'prompt', 'dashboard'}
vim.g.minimap_close_filetypes = {'startify', 'netrw', 'vim-plug', 'dashboard', 'terminal'}
vim.api.nvim_command([[
au! BufEnter *.* setlocal formatoptions-=c formatoptions-=r formatoptions -=0
]])

return {
  'wfxr/minimap.vim'
}
