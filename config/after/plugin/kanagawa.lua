require('kanagawa').setup({
	compile			= false,
	undercurl		= true,
	commentStyle	= { italic = false },
	functionStyle	= {},
	keywordStyle	= { italic = false },
	statementStyle	= { bold = false },
	typeStyle		= {},
	transparent		= true,
	dimInactive		= false,
	terminalColors	= true,

	colors = {
		palette = {},
		theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
	},

	overrides = function(colors)
		return {
			-- TreeSitter capture updates for modern nvim-treesitter
			["@string.regexp"]			= { link = "@string.regex" },
			["@variable.parameter"]		= { link = "@parameter" },
			["@exception"]				= { link = "@exception" },
			["@string.special.symbol"]	= { link = "@symbol" },
			
			-- C-specific improvements
			["@type.builtin.c"]		= { fg = colors.palette.crystalBlue		},
			["@constant.builtin.c"]	= { fg = colors.palette.surimiOrange	},
		}
	end,

	theme = "wave",
	background = {
		dark	= "wave",
		light	= "lotus"
	},
})

vim.cmd([[colorscheme kanagawa]])

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "kanagawa",
	callback = function()
		vim.cmd('highlight LineNr guifg=#727169 guibg=NONE')
		vim.cmd('highlight LineNrAbove guifg=#727169 guibg=NONE')
		vim.cmd('highlight LineNrBelow guifg=#727169 guibg=NONE')
		vim.cmd('highlight CursorLineNr guifg=#A3D4D5 guibg=NONE')
	end,
})
