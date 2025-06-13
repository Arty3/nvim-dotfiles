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
		-- Keep as this due to really odd rendering
		-- bug with emojis and unicode chars
		selection_caret	= "➜  ",
		prompt_prefix	= " ▶ ",
		multi_icon		= "✓",
	},
	pickers = {
		find_files = {
			hidden = false,
		},
	},
})

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "kanagawa",
	callback = function()
		-- Kanagawa Wave Telescope theme

		vim.cmd('highlight TelescopeNormal guifg=#FF9E3B guibg=#1F1F28')
		vim.cmd('highlight TelescopeBorder guifg=#54546D')
		vim.cmd('highlight TelescopeTitle guifg=#7E9CD8 gui=bold')

		vim.cmd('highlight TelescopePromptNormal guifg=#98BB6C guibg=#2A2A37')
		vim.cmd('highlight TelescopePromptBorder guifg=#54546D')
		vim.cmd('highlight TelescopePromptTitle guifg=#7E9CD8 gui=bold')
		vim.cmd('highlight TelescopePromptPrefix guifg=#FF5D62')

		vim.cmd('highlight TelescopeResultsNormal guifg=#98BB6C guibg=#1F1F28')
		vim.cmd('highlight TelescopeResultsBorder guifg=#54546D')
		vim.cmd('highlight TelescopeResultsTitle guifg=#98BB6C gui=bold')

		vim.cmd('highlight TelescopePreviewNormal guifg=#FF9E3B guibg=#1F1F28')
		vim.cmd('highlight TelescopePreviewBorder guifg=#54546D')
		vim.cmd('highlight TelescopePreviewTitle guifg=#7E9CD8 gui=bold')

		vim.cmd('highlight TelescopeSelection guifg=#FF9E3B guibg=#2A2A37 gui=bold')
		vim.cmd('highlight TelescopeSelectionCaret guifg=#FF5D62 gui=bold')
		vim.cmd('highlight TelescopeMatching guifg=#E46876 gui=bold')

		vim.cmd('highlight TelescopeResultsClass guifg=#7E9CD8')
		vim.cmd('highlight TelescopeResultsConstant guifg=#98BB6C')
		vim.cmd('highlight TelescopeResultsField guifg=#FF9E3B')
		vim.cmd('highlight TelescopeResultsFunction guifg=#7E9CD8')
		vim.cmd('highlight TelescopeResultsMethod guifg=#7E9CD8')
		vim.cmd('highlight TelescopeResultsOperator guifg=#938AA9')
		vim.cmd('highlight TelescopeResultsStruct guifg=#7FB4CA')
		vim.cmd('highlight TelescopeResultsVariable guifg=#FF9E3B')

		vim.cmd('highlight TelescopeResultsIdentifier guifg=#98BB6C')
		vim.cmd('highlight TelescopeResultsNumber guifg=#D27E99')
		vim.cmd('highlight TelescopeResultsComment guifg=#727169')
		vim.cmd('highlight TelescopeResultsSpecialComment guifg=#938AA9')

		vim.cmd('highlight TelescopeResultsDiffAdd guifg=#76946A')
		vim.cmd('highlight TelescopeResultsDiffChange guifg=#DCA561')
		vim.cmd('highlight TelescopeResultsDiffDelete guifg=#E46876')
		vim.cmd('highlight TelescopeResultsDiffUntracked guifg=#FF9E3B')

		vim.cmd('highlight TelescopeMultiSelection guifg=#FF9E3B')
		vim.cmd('highlight TelescopeMultiIcon guifg=#FF9E3B')
		vim.cmd('highlight TelescopePromptCounter guifg=#727169')
	end,
})

if vim.g.colors_name == "kanagawa" then
	vim.cmd('doautocmd ColorScheme kanagawa')
end
