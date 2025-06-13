-- Show line numbers on the left
vim.opt.nu				= true
vim.opt.number			= true
-- Show relative line num (for e.g. 5j)
vim.opt.relativenumber	= true

-- Cursor position as line not column
vim.opt.guicursor = {
	"i-ci-ve:ver25-blinkon500",
	"i-ci-ve:ver25-blinkon500",
	"i-ci-ve:ver25-blinkon500",
}
vim.opt.cursorline		= false
vim.opt.cursorcolumn	= false

-- Remove annoying backup files
vim.opt.swapfile		= false
vim.opt.backup			= false

-- No highlighting of search results
vim.opt.hlsearch		= false
-- Show matches as you type
vim.opt.incsearch		= true
vim.opt.ignorecase		= true
vim.opt.smartcase		= true
-- Don't wrap around end/beginning
vim.opt.wrapscan		= false

-- Switch buffers without saving
vim.opt.hidden			= true
-- Ask before closing unsaved files
vim.opt.confirm			= true

-- Enable 24-bit colors
vim.opt.termguicolors	= true

-- Disable line wrapping
vim.wo.wrap				= false

-- Use system clipboard
vim.opt.clipboard		= "unnamedplus"

-- Faster diagostics and key sequence timeout
vim.opt.updatetime		= 250
vim.opt.timeoutlen		= 300

-- Disable action column (git, breakponts, etc.)
vim.opt.signcolumn		= "no"

-- Command line height
vim.opt.cmdheight		= 1
-- Show partial commands
vim.opt.showcmd			= true
-- Enhanced command line completion
vim.opt.wildmenu		= true
vim.opt.wildmode		= "longest:full,full"

-- New horizontal splits open below
vim.opt.splitbelow		= true
-- New vertical splits open to the right
vim.opt.splitright		= true

-- Enable persistent undo
vim.opt.undofile		= true
vim.opt.undodir			= vim.fn.stdpath("cache") .. "/undo"
