require("neo-tree").setup({
	close_if_last_window = true, -- Close Neo-tree if it's the last window
	popup_border_style = "rounded",
	enable_git_status = true,
	enable_diagnostics = true,
	
	-- Follow Sonokai theme automatically
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
				-- Change type
				added     = "✚",
				modified  = "",
				deleted   = "✖",
				renamed   = "󰁕",
				-- Status type
				untracked = "",
				ignored   = "",
				unstaged  = "󰄱",
				staged    = "",
				conflict  = "",
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
			-- Custom project keybinds
			["P"] = function(state)
				local node = state.tree:get_node()
				if node.type == "directory" then
					-- Change working directory to selected folder
					vim.cmd('cd ' .. node.path)
					vim.cmd('Neotree close')
					vim.cmd('Neotree reveal')
					print("Set working directory: " .. node.path)
				else
					print("Please select a directory")
				end
			end,
			
			["<leader>p"] = function(state)
				-- Quick access to project manager from Neo-tree
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
		-- Tokyo Night color palette
		-- Directories
		vim.cmd('highlight NeoTreeDirectoryName guifg=#7AA2F7 gui=bold')     -- Tokyo Night blue
		vim.cmd('highlight NeoTreeDirectoryIcon guifg=#7AA2F7')              -- Tokyo Night blue
		
		-- Files
		vim.cmd('highlight NeoTreeFileName guifg=#C0CAF5')                   -- Tokyo Night foreground
		vim.cmd('highlight NeoTreeFileIcon guifg=#9ECE6A')                   -- Tokyo Night green
		
		-- Git status
		vim.cmd('highlight NeoTreeGitAdded guifg=#9ECE6A')                   -- Green for added
		vim.cmd('highlight NeoTreeGitModified guifg=#E0AF68')                -- Yellow for modified
		vim.cmd('highlight NeoTreeGitDeleted guifg=#F7768E')                 -- Red for deleted
		vim.cmd('highlight NeoTreeGitUntracked guifg=#BB9AF7')               -- Purple for untracked
		vim.cmd('highlight NeoTreeGitIgnored guifg=#565F89')                 -- Dark gray for ignored
		vim.cmd('highlight NeoTreeGitConflict guifg=#FF9E64')                -- Orange for conflicts
		vim.cmd('highlight NeoTreeGitUnstaged guifg=#E0AF68')                -- Yellow for unstaged
		vim.cmd('highlight NeoTreeGitStaged guifg=#9ECE6A')                  -- Green for staged
		
		-- Tree structure
		vim.cmd('highlight NeoTreeIndentMarker guifg=#3B4261')               -- Subtle indent lines
		vim.cmd('highlight NeoTreeExpander guifg=#7AA2F7')                   -- Blue expand/collapse icons
		
		-- Special files
		vim.cmd('highlight NeoTreeSymbolicLinkTarget guifg=#7DCFFF')          -- Cyan for symlinks
		vim.cmd('highlight NeoTreeRootName guifg=#BB9AF7 gui=bold')          -- Purple for root
		vim.cmd('highlight NeoTreeFloatBorder guifg=#3B4261')                -- Border color
		vim.cmd('highlight NeoTreeFloatTitle guifg=#7AA2F7 gui=bold')        -- Title color
		
		-- File types with specific colors
		vim.cmd('highlight NeoTreeFileNameOpened guifg=#E0AF68 gui=italic')  -- Opened files in yellow
		vim.cmd('highlight NeoTreeDimText guifg=#565F89')                    -- Dimmed text
		vim.cmd('highlight NeoTreeFilterTerm guifg=#F7768E gui=bold')        -- Filter terms in red
		vim.cmd('highlight NeoTreeTitleBar guifg=#1A1B26 guibg=#7AA2F7')     -- Title bar
		
		-- Cursor and selection
		vim.cmd('highlight NeoTreeCursorLine guibg=#2A2E36')                 -- Cursor line background
		vim.cmd('highlight NeoTreeWinSeparator guifg=#3B4261')               -- Window separator
		
		-- Modified files
		vim.cmd('highlight NeoTreeModified guifg=#E0AF68')                   -- Modified indicator
		vim.cmd('highlight NeoTreeHiddenByName guifg=#565F89')               -- Hidden files
		
		-- Preview
		vim.cmd('highlight NeoTreePreviewBorder guifg=#3B4261')              -- Preview border
		vim.cmd('highlight NeoTreePreviewDirectory guifg=#7AA2F7')           -- Preview directory
		vim.cmd('highlight NeoTreePreviewFile guifg=#C0CAF5')                -- Preview file
	end,
})