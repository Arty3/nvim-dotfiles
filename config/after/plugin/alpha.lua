local alpha		= require('alpha')
local dashboard	= require('alpha.themes.dashboard')

-- Set header
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

-- Set menu
dashboard.section.buttons.val = {
	dashboard.button("n", "✨ New project", ":lua require('own.project_manager').new_project()<CR>"),
	dashboard.button("p", "📁 Open project", ":lua require('own.project_manager').telescope_projects()<CR>"),
	dashboard.button("e", "📄 New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("f", "🔍 Find file", ":Telescope find_files<CR>"),
	dashboard.button("r", "🕗 Recent files", ":Telescope oldfiles<CR>"),
	dashboard.button("c", "⚙  Configuration", ":e $MYVIMRC<CR>"),
	dashboard.button("q", "❌ Quit NVIM", ":qa<CR>"),
}

-- Footer
dashboard.section.footer.val = "🌌 Have a great day!"

-- Send config to alpha
alpha.setup(dashboard.opts)

-- Disable folding on alpha buffer
vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
