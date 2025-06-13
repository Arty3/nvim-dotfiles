local alpha		= require('alpha')
local dashboard	= require('alpha.themes.dashboard')

dashboard.section.header.val = {
	"                                                    ",
	"                                                    ",
	"                                                    ",
	"                                                    ",
	"                                                    ",
	"                                                    ",
	"                                                    ",
	"                                                    ",
	"                                                    ",
	"                                                    ",
	"                                                    ",
}

dashboard.section.buttons.val = {
	dashboard.button("n", "✨ ▸ New project", ":lua require('own.project_manager').new_project()<CR>"),
	dashboard.button("p", "📁 ▸ Open project", ":lua require('own.project_manager').telescope_projects()<CR>"),
	dashboard.button("e", "📄 ▸ New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("f", "🔍 ▸ Find file", ":lua require('own.project_manager').find_files()<CR>"),
	dashboard.button("r", "🕗 ▸ Recent files", ":Telescope oldfiles<CR>"),
	dashboard.button("c", "⚙  ▸ Configuration", ":lua require('own.project_manager').open_config()<CR>"),
	dashboard.button("q", "❌ ▸ Quit NVIM", ":qa<CR>"),
}

for _, button in ipairs(dashboard.section.buttons.val) do
	button.opts = button.opts or {}
	button.opts.hl = {
		{ "AlphaShortcut", 0, 1 },  -- First character (the key) gets bold purple
		{ "AlphaButtons", 1, -1 },  -- Rest of the text gets blue
	}
	button.opts.hl_shortcut = "AlphaShortcut"
end

local wsl = require('own.wsl')
dashboard.section.footer.val = {
	"",
	"",
	"",
	"",
	wsl.is_wsl() and "📌 Running on WSL!" or "📌 Running on Windows!"
}

dashboard.section.footer.opts.hl = "AlphaFooter"

vim.cmd('highlight AlphaShortcut guifg=#957FB8 gui=bold')
vim.cmd('highlight AlphaButtons guifg=#7FB4CA gui=bold')
vim.cmd('highlight AlphaFooter guifg=#D27E99 gui=italic')

alpha.setup(dashboard.opts)

vim.api.nvim_create_autocmd("User", {
	pattern = "AlphaReady",
	callback = function()
		vim.cmd('highlight AlphaShortcut guifg=#957FB8 gui=bold')
		vim.cmd('highlight AlphaButtons guifg=#7FB4CA gui=bold')
		vim.cmd('highlight AlphaFooter guifg=#D27E99 gui=italic')
	end,
})

-- Disable folding and hide cursor on alpha buffer
vim.cmd([[
	autocmd FileType alpha setlocal nofoldenable
	autocmd FileType alpha setlocal guicursor=a:ver1-Cursor/lCursor
	autocmd FileType alpha lua vim.cmd('hi Cursor guifg=' .. vim.fn.synIDattr(vim.fn.hlID('Normal'), 'bg') .. ' guibg=' .. vim.fn.synIDattr(vim.fn.hlID('Normal'), 'bg'))
	autocmd BufLeave * if &ft != 'alpha' | set guicursor& | hi Cursor ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE | endif
]])