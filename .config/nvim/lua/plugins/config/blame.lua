return {
  "f-person/git-blame.nvim",
	event = "User AlphaClosed",
  config = function ()
    vim.cmd([[
    let g:gitblame_delay = 1000
    let g:gitblame_message_template = '#<sha> -> "<summary>" by <author> • <date>'
    let g:gitblame_date_format = '%r'
    ]])
  end
}
