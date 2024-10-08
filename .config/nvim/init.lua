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
vim.g.zig_fmt_autosave = 0
require("lazy").setup("plugins", {
	change_detection = {
		enabled = false
	}
})
require('config')
require('core.mappings')
require('core.indentation')
require('core.go-tags')
require('core.commands')
