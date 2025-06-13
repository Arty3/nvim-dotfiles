local function bootstrap_pckr()
	local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"
	print(pckr_path)

	if not (vim.uv or vim.loop).fs_stat(pckr_path) then
		vim.fn.system({
			'git',
			'clone',
			"--filter=blob:none",
			'https://github.com/lewis6991/pckr.nvim',
			pckr_path
		})
	end

	vim.opt.rtp:prepend(pckr_path)
end

bootstrap_pckr()

require('pckr').add{
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.5',
		requires = {
			'nvim-lua/plenary.nvim'
		}
	};

	-- Color theme
	'rebelot/kanagawa.nvim';

	{
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
	};

	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x',
		requires = {
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
			'neovim/nvim-lspconfig',
			'hrsh7th/nvim-cmp',
			'hrsh7th/cmp-nvim-lsp',
			'L3MON4D3/LuaSnip',
		}
	};

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- File icons
			"MunifTanjim/nui.nvim",
		}
	};

	{
		'goolord/alpha-nvim',
		requires = { 'nvim-tree/nvim-web-devicons' },
	};

	'ray-x/lsp_signature.nvim';
	'Raimondi/delimitMate';
	'itchyny/lightline.vim';
	'andweeb/presence.nvim';
}
