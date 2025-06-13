require'nvim-treesitter.configs'.setup {
	ensure_installed = {
		"c_sharp",	"c",		"lua",		"vim",			"vimdoc", 		"query",
		"go",		"rust",		"python",	"javascript",	"typescript",	"d",
		"java",		"kotlin",	"bash",		"json",			"yaml", 		"toml", 
		"ruby",		"markdown",	"html",		"css",			"php",			"r",
		"glsl",		"dart",		"sql",		"asm",			"cpp",			"cuda"
	},

	sync_install	= false,
	auto_install	= false,
	prefer_git		= false,

	highlight = {
		enable								= true,
		additional_vim_regex_highlighting	= false,
	},
}
