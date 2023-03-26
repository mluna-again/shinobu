local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

require("lazy").setup({
	require('plugins.config.kanagawa'),
	require('plugins.config.copilot'),
	'neovim/nvim-lspconfig',
	'hrsh7th/cmp-nvim-lsp',
	'hrsh7th/cmp-buffer',
	'hrsh7th/cmp-path',
	'hrsh7th/cmp-cmdline',
	'quangnguyen30192/cmp-nvim-ultisnips',
	require('plugins.config.nvim-cmp'),
	require('plugins.config.mason'),
	require('plugins.config.lsp'),
	require('plugins.config.dashboard'),
	require('plugins.config.conjure'),
	require('plugins.config.telescope'),
	require('plugins.config.trouble'),
	require('plugins.config.which_key'),
	require('plugins.config.toggleterm'),
	require('plugins.config.nvim-tree'),
	require('plugins.config.ultisnips'),
	require('plugins.config.neoscroll'),
	require('plugins.config.tags'),
	require('plugins.config.emmet'),
	require('plugins.config.vim-test'),
	require('plugins.config.todo'),
	require('plugins.config.lightspeed'),
	require('plugins.config.treesitter'),
	require('plugins.config.neoformat'),
	require('plugins.config.lualine'),
	require('plugins.config.devicons'),
	require('plugins.config.bufferline'),
	require('plugins.config.gitsigns'),
	require('plugins.config.ufo'),
	require('plugins.config.autopairs'),
	require('plugins.config.table-mode'),
	require('plugins.config.wordmotion'),
	'RRethy/nvim-treesitter-endwise',
	'editorconfig/editorconfig-vim',
	'nvim-lua/popup.nvim',
	'nvim-lua/plenary.nvim',
	'elixir-editors/vim-elixir',
	'junegunn/goyo.vim',
	'tpope/vim-obsession',
	'junegunn/fzf.vim',
	'junegunn/fzf',
	'tpope/vim-commentary',
	'alvan/vim-closetag',
	'moll/vim-bbye',
	'xolox/vim-misc',
	'rhysd/git-messenger.vim',
	'tpope/vim-repeat'
})
