local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup({function(use)
	use(require('plugins.config.dashboard'))
	use(require('plugins.config.neoformat'))
	use(require('plugins.config.nvim-cmp'))
	use(require('plugins.config.bufferline'))
	use(require('plugins.config.lsp-installer'))
	use(require('plugins.config.trouble'))
	use(require('plugins.config.which_key'))
	use(require('plugins.config.floaterm'))
	use(require('plugins.config.nvim-tree'))
	use(require('plugins.config.ultisnips'))
	use(require('plugins.config.neoscroll'))
	use(require('plugins.config.tags'))
	use(require('plugins.config.emmet'))
	use(require('plugins.config.vim-test'))
	use(require('plugins.config.neoclip'))
	use(require('plugins.config.emoji'))
	use(require('plugins.config.tables'))
	use('nvim-telescope/telescope.nvim')
	use('nvim-lua/popup.nvim')
	use('nvim-lua/plenary.nvim')
	use('morhetz/gruvbox')
	use('elixir-editors/vim-elixir')
	use('tpope/vim-endwise')
	use('junegunn/goyo.vim')
	use('tpope/vim-obsession')
	use('Yggdroot/indentLine')
	use('junegunn/fzf.vim')
	use('junegunn/fzf')
	use('kyazdani42/nvim-web-devicons')
	use('tpope/vim-commentary')
	use('jiangmiao/auto-pairs')
	use('alvan/vim-closetag')
	use('moll/vim-bbye')
	use('leafgarland/typescript-vim')
	use('peitalin/vim-jsx-typescript')
	use('xolox/vim-misc')
	use('mluna711/dark_cherry_mystery_vim')
	use('leafgarland/typescript-vim')
	use('peitalin/vim-jsx-typescript')
	use('vim-crystal/vim-crystal')
	use('udalov/kotlin-vim')
	use('rebelot/kanagawa.nvim')
	use('tpope/vim-fugitive')
	use('neovim/nvim-lspconfig')
	use('hrsh7th/cmp-nvim-lsp')
	use('hrsh7th/cmp-buffer')
	use('hrsh7th/cmp-path')
	use('hrsh7th/cmp-cmdline')

	if packer_bootstrap then
		require('packer').sync()
	end
end,
config = {
	display = {
		open_fn = function()
			return require('packer.util').float({ border = 'single' })
		end
	}
}})
