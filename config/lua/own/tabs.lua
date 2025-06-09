-- Use actual tab characters
vim.opt.expandtab		= false
-- Display width
vim.opt.tabstop			= 4
-- Indentation width
vim.opt.shiftwidth		= 4
-- Tab key behavior
vim.opt.softtabstop		= 4

-- Language-specific tab overrides (2 spaces, no tabs)
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"typescript", "javascript",
		"html", "css", "tex"
	},
	callback = function()
		-- Convert tabs to spaces
		vim.opt_local.expandtab		= true
		-- 2 space width
		vim.opt_local.tabstop		= 2
		vim.opt_local.shiftwidth	= 2
		vim.opt_local.softtabstop	= 2
	end,
})

-- Auto-fix existing file indentation on open
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local ft = vim.bo.filetype
		local space_langs = {
			"typescript", "javascript",
			"html", "css", "tex"
		}
		
		if not vim.tbl_contains(space_langs, ft) then
			-- Convert leading spaces to tabs
			vim.cmd([[silent! %s/^\(\s\s\s\s\)\+/\=repeat('\t', len(submatch(0))/4)/g]])
		else
			-- Convert tabs to spaces for space-preferred files
			vim.cmd([[silent! %s/^\t\+/\=repeat('  ', len(submatch(0)))/g]])
		end
	end,
})

-- Show invisible characters
vim.opt.list			= true
vim.opt.listchars		= "tab:  ,trail:.,extends:»,precedes:«,nbsp:×"
