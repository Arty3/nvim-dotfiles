-- Fallback to Vim syntax for problematic Tree-sitter parsers

-- C++ files
vim.api.nvim_create_autocmd("FileType", {
	pattern = {"cpp"},
	callback = function()
		vim.opt_local.syntax = "cpp"
		vim.cmd("runtime! syntax/cpp.vim")
	end,
})

-- CUDA files
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
	pattern = {"*.cu", "*.cuh", "*.cuda"},
	callback = function()
		vim.bo.filetype			= "cuda"
		vim.opt_local.syntax	= "cuda"
		vim.cmd("runtime! syntax/cuda.vim")
	end,
})
