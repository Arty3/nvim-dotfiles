local M = {}

function M.is_wsl()
	-- WSL will always have this directory
	return vim.fn.isdirectory("/mnt/c") == 1
end

return M
