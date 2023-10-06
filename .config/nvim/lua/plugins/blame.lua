return {
	"f-person/git-blame.nvim",
	event = "VeryLazy",
	config = function()
		vim.cmd([[
    let g:gitblame_delay = 1000
    let g:gitblame_message_template = '#<sha> -> "<summary>" by <author> • <date>'
    let g:gitblame_date_format = '%r'
		" let g:gitblame_message_when_not_committed = '#000000 -> "Not commited yet" by nil • 1970/01/01'
		let g:gitblame_message_when_not_committed = ''
    ]])
	end,
}
