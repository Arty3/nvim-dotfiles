local builtin = require('telescope.builtin')

vim.keymap.set('n', 'ff', builtin.find_files, {})
vim.keymap.set('n', 'fg', builtin.live_grep, {})

require('telescope').setup({
	defaults = {
		file_ignore_patterns = {
			"^%.git/",
			"^%.gitignore",
			"^%.gitmodules", 
			"^%.github/",
			"^node_modules/",
			"^%.env",
			"^%.DS_Store",
		},
	},
	pickers = {
		find_files = {
			hidden = false,
		},
	},
})
