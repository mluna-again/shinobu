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

vim.o.guifont = "FiraCode Nerd Font Retina"
vim.g.mapleader = " "
require("lazy").setup("plugins")
require('config')
require('core.mappings')
require('core.indentation')
require('core.go-tags')
require('core.commands')
