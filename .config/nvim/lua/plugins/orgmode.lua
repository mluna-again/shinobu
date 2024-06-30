return {
	"nvim-orgmode/orgmode",
	dependencies = { "folke/which-key.nvim" },
	lazy = true,
	cmd = "Org",
	ft = { "org" },
	config = function()
		require("orgmode").setup({
			-- org_agenda_files = '~/orgfiles/**/*',
			-- org_default_notes_file = '~/orgfiles/refile.org',
			org_todo_keywords = { "TODO", "DOING", "|", "DONE" },
			org_startup_folded = "showeverything",
			mappings = {
				org = {
					org_toggle_checkbox = "<leader>oo",
					org_timestamp_up = "<leader>o>",
					org_timestamp_down = "<leader>o<",
					org_open_at_point = "<cr>",
				},
			},
		})

		local wk = require("which-key")
		wk.register({
			name = "Orgmode",
		}, { prefix = "<leader>o" })

		local notes_dir = vim.fs.joinpath(os.getenv("HOME"), "Notes")

		vim.api.nvim_create_user_command("Org", function(args)
			local file = args.fargs[1]
			local filepath = vim.fs.joinpath(notes_dir, file)
			if vim.fn.filereadable(filepath) == 0 then
				print("File doesn't exist!")
				return
			end

			vim.cmd("e " .. filepath)
		end, {
			desc = "Open an index Org file from ~/Notes",
			force = false,
			nargs = "?",
			complete = function(arg, cmd, cursor)
				local files = {}
				for f in vim.fs.dir(notes_dir, { depth = 5 }) do
					if string.find(f, ".org") then
						table.insert(files, f)
					end
				end

				return files
			end,
		})
	end,
}
