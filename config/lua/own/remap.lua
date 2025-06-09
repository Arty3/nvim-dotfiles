vim.g.mapleader = " "

-- Insert mode escapes
vim.keymap.set(
	'i', 'jj', '<esc>'
)

-- File explorer
vim.keymap.set(
	'n', '<leader>e',
	':Neotree toggle<CR>',
	{ silent = true }
)

-- Reveal current file
vim.keymap.set(
	'n', '<leader>ef',
	':Neotree reveal<CR>',
	{ silent = true }
)

-- Git status view
vim.keymap.set(
	'n', '<leader>eg',
	':Neotree git_status<CR>',
	{ silent = true }
)

-- Buffer view
vim.keymap.set(
	'n', '<leader>eb',
	':Neotree buffers<CR>',
	{ silent = true }
)

-- Diagnostics
vim.keymap.set(
	'n', '<leader>m', function()
	vim.diagnostic.open_float(
		{ scope = 'line', focusable = false }
	) end,
	{ silent = true }
)

-- LSP functions
vim.keymap.set(
	'n', 'gR',
	vim.lsp.buf.rename,
	{ silent = true }
)

vim.keymap.set(
	'n', '<leader>ca',
	vim.lsp.buf.code_action,
	{ silent = true }
)
