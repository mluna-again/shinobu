vim.cmd([[
map sx <Plug>Lightspeed_s
map Sx <Plug>Lightspeed_S
map SX <Plug>Lightspeed_S
]])

return {
	'ggandor/lightspeed.nvim',
	config = function()
		require'lightspeed'.setup {}
	end
}
