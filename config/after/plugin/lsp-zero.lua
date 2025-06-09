local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
	lsp_zero.default_keymaps({buffer = bufnr})
end)

local cmp = require('cmp')

cmp.setup({
	-- Enable except for C/C++
	enabled = function()
		local ft = vim.bo.filetype
		if ft == "c" or ft == "cpp" then
			return false
		end
		return true
	end,
	completion = {
		completeopt = 'menu,menuone,noinsert'
	},
	mapping = {
		['<CR>'] = cmp.mapping.confirm({ 
			behavior	= cmp.ConfirmBehavior.Insert,
			select		= false
		}),

		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.confirm({ select = true })
			else
				fallback()
			end
		end, { 'i', 's' }),

		['<S-Tab>']	= cmp.mapping.select_prev_item(),
		['<Down>']	= cmp.mapping.select_next_item(),
		['<Up>']	= cmp.mapping.select_prev_item(),
	},
	preselect = cmp.PreselectMode.Item,
})

require('mason').setup({})
require('mason-lspconfig').setup({
	ensure_installed = {},
	handlers = {
		lsp_zero.default_setup,
	},
})

require('lsp_signature').setup({
	bind = true,
	handler_opts = {
		border = "rounded"
	}
})
