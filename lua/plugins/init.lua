local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup({function(use)
	use(require('plugins.config.dashboard'))
	use(require('plugins.config.neoformat'))
	use('nvim-telescope/telescope.nvim')
	use('nvim-lua/popup.nvim')
	use('nvim-lua/plenary.nvim')
	use('morhetz/gruvbox')
	use('elixir-editors/vim-elixir')
	use('tpope/vim-endwise')
	use('junegunn/goyo.vim')
	use(require('plugins.config.floaterm'))
	use('tpope/vim-obsession')
	use('Yggdroot/indentLine')
	use('junegunn/fzf.vim')
	use('junegunn/fzf')
	use('kyazdani42/nvim-web-devicons')
	use(require('plugins.config.nvim-tree'))
	use('tpope/vim-commentary')
	use('jiangmiao/auto-pairs')
	use(require('plugins.config.ultisnips'))
	use('alvan/vim-closetag')
	use(require('plugins.config.neoscroll'))
	use(require('plugins.config.tags'))
	use(require('plugins.config.emmet'))
	use('moll/vim-bbye')
	use(require('plugins.config.coc'))
	use(require('plugins.config.vim-test'))
	use('leafgarland/typescript-vim')
	use('peitalin/vim-jsx-typescript')
	use(require('plugins.config.neoclip'))
	use(require('plugins.config.emoji'))
	use('xolox/vim-misc')
	use(require('plugins.config.tables'))
	use('mluna711/dark_cherry_mystery_vim')
	use('leafgarland/typescript-vim')
	use('peitalin/vim-jsx-typescript')
	use('vim-crystal/vim-crystal')
	use('udalov/kotlin-vim')
	use('rebelot/kanagawa.nvim')
	use('tpope/vim-fugitive')

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
