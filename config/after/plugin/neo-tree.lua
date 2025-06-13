require("neo-tree").setup({
	close_if_last_window = true,
	popup_border_style = "rounded",
	enable_git_status = true,
	enable_diagnostics = true,
	
	default_component_configs = {
		container = {
			enable_character_fade = true
		},
		indent = {
			indent_size = 2,
			padding = 1,
			with_markers = true,
			indent_marker = "│",
			last_indent_marker = "└",
			highlight = "NeoTreeIndentMarker",
		},
		icon = {
			folder_closed = "",
			folder_open = "",
			folder_empty = "󰜌",
			default = "*",
			highlight = "NeoTreeFileIcon"
		},
		modified = {
			symbol = "[+]",
			highlight = "NeoTreeModified",
		},
		name = {
			trailing_slash = false,
			use_git_status_colors = true,
			highlight = "NeoTreeFileName",
		},
		git_status = {
			symbols = {
				added		= "✚",
				deleted		= "✖",
				modified	= "●",
				renamed		= "➜",
				untracked	= "?",
				ignored		= "◌",
				unstaged	= "●",
				staged		= "✓",
				conflict	= "⚠",
			}
		},
	},
	
	window = {
		position = "left",
		width = 30,
		mapping_options = {
			noremap = true,
			nowait = true,
		},
		mappings = {
			["<space>"] = { 
				"toggle_node", 
				nowait = false,
			},
			["<2-LeftMouse>"] = "open",
			["<cr>"] = "open",
			["<esc>"] = "cancel",
			["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
			["l"] = "focus_preview",
			["S"] = "open_split",
			["s"] = "open_vsplit",
			["t"] = "open_tabnew",
			["w"] = "open_with_window_picker",
			["C"] = "close_node",
			["z"] = "close_all_nodes",
			["a"] = { 
				"add",
				config = {
					show_path = "none"
				}
			},
			["A"] = "add_directory",
			["d"] = "delete",
			["r"] = "rename",
			["y"] = "copy_to_clipboard",
			["x"] = "cut_to_clipboard",
			["p"] = "paste_from_clipboard",
			["c"] = "copy",
			["m"] = "move",
			["q"] = "close_window",
			["R"] = "refresh",
			["?"] = "show_help",
			["<"] = "prev_source",
			[">"] = "next_source",
			["i"] = "show_file_details",
			["P"] = function(state)
				local node = state.tree:get_node()
				if node.type == "directory" then
					vim.cmd('cd ' .. node.path)
					vim.cmd('Neotree close')
					vim.cmd('Neotree reveal')
					print("Set working directory: " .. node.path)
				else
					print("Please select a directory")
				end
			end,
			
			["<leader>p"] = function(state)
				require('project_manager').project_menu()
			end,
		}
	},
	
	filesystem = {
		filtered_items = {
			visible				= false,
			hide_dotfiles		= false,
			hide_gitignored		= false,
			hide_hidden			= false,
		},
		follow_current_file = {
			enabled				= true,
			leave_dirs_open		= false,
		},
		group_empty_dirs		= false,
		hijack_netrw_behavior	= "open_default",
		use_libuv_file_watcher	= true,
	},
	
	buffers = {
		follow_current_file = {
			enabled				= true,
			leave_dirs_open		= false,
		},
		group_empty_dirs		= true,
		show_unloaded			= true,
	},
	
	git_status = {
		window = {
			position = "float",
			mappings = {
				["A"]	= "git_add_all",
				["gu"]	= "git_unstage_file",
				["ga"]	= "git_add_file",
				["gr"]	= "git_revert_file",
				["gc"]	= "git_commit",
				["gp"]	= "git_push",
				["gg"]	= "git_commit_and_push",
			}
		}
	},
})

vim.api.nvim_create_autocmd("FileType", {
   pattern = "neo-tree",
   callback = function()
   	vim.cmd('highlight NeoTreeDirectoryName guifg=#7E9CD8 gui=bold')
   	vim.cmd('highlight NeoTreeDirectoryIcon guifg=#7E9CD8 gui=bold')

   	vim.cmd('highlight NeoTreeFileName guifg=#A3D4D5')
   	vim.cmd('highlight NeoTreeFileIcon guifg=#A3D4D5')

   	vim.cmd('highlight NeoTreeGitAdded guifg=#98BB6C gui=bold')
   	vim.cmd('highlight NeoTreeGitModified guifg=#98BB6C gui=bold')
   	vim.cmd('highlight NeoTreeGitDeleted guifg=#E82424 gui=bold')
   	vim.cmd('highlight NeoTreeGitUntracked guifg=#D27E99 gui=bold')
   	vim.cmd('highlight NeoTreeGitIgnored guifg=#727169')
   	vim.cmd('highlight NeoTreeGitConflict guifg=#FF5D62 gui=bold')
   	vim.cmd('highlight NeoTreeGitUnstaged guifg=#FFA066 gui=bold')
   	vim.cmd('highlight NeoTreeGitStaged guifg=#87A987 gui=bold')

   	vim.cmd('highlight NeoTreeIndentMarker guifg=#625E83')
   	vim.cmd('highlight NeoTreeExpander guifg=#C4B5FD gui=bold')

   	vim.cmd('highlight NeoTreeSymbolicLinkTarget guifg=#7FB4CA gui=italic')
   	vim.cmd('highlight NeoTreeRootName guifg=#E46876 gui=bold')
   	vim.cmd('highlight NeoTreeFloatBorder guifg=#957FB8')
   	vim.cmd('highlight NeoTreeFloatTitle guifg=#E6C384 gui=bold')
   	
   	vim.cmd('highlight NeoTreeFileNameOpened guifg=#FF9E3B gui=bold,italic')
   	vim.cmd('highlight NeoTreeDimText guifg=#727169')
   	vim.cmd('highlight NeoTreeFilterTerm guifg=#C34043 gui=bold')
   	vim.cmd('highlight NeoTreeTitleBar guifg=#1F1F28 guibg=#E6C384')
   	
   	vim.cmd('highlight NeoTreeCursorLine guibg=#2D4F67')
   	vim.cmd('highlight NeoTreeWinSeparator guifg=#957FB8')
   	
   	vim.cmd('highlight NeoTreeModified guifg=#98BB6C gui=bold')
   	vim.cmd('highlight NeoTreeHiddenByName guifg=#727169')
   	
   	vim.cmd('highlight NeoTreePreviewBorder guifg=#957FB8')
   	vim.cmd('highlight NeoTreePreviewDirectory guifg=#7E9CD8 gui=bold')
   	vim.cmd('highlight NeoTreePreviewFile guifg=#A3D4D5')

   	vim.cmd('highlight NeoTreeTitleText guifg=#E46876 gui=bold')
   	vim.cmd('highlight NeoTreeTabInactive guifg=#E46876')
   	vim.cmd('highlight NeoTreeTabActive guifg=#E46876 gui=bold')

   	vim.cmd('highlight NeoTreeMessage guifg=#E6C384')
   	vim.cmd('highlight NeoTreeStats guifg=#7FB4CA')
   	vim.cmd('highlight NeoTreeStatsHeader guifg=#C4B5FD gui=bold')
   end,
})
