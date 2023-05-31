return {
	'williamboman/mason.nvim',
	event = "User AlphaClosed",
	config = function()
		require('mason').setup()
	end
}
