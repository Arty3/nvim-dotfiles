-- My own custom project manager
local M = {}

M.projects_dir = "C:\\Users\\Luca\\Desktop\\Projects"

-- Helper function to close Alpha dashboard
local function close_alpha()
	-- Find and close alpha buffer
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_get_option(buf, 'filetype') == 'alpha' then
			vim.api.nvim_buf_delete(buf, { force = true })
			break
		end
	end
end

-- Browse existing projects with Neo-tree
function M.browse_projects()
	-- Close Alpha dashboard
	close_alpha()
	
	vim.cmd('cd ' .. M.projects_dir)
	vim.cmd('Neotree reveal')
	print("Browse projects in Neo-tree. Press 'P' on a project folder to set it as working directory.")
end

-- Create new project with language selection
function M.new_project()
	-- First, get available languages (directories in Projects)
	local languages = {}
	local handle = vim.loop.fs_scandir(M.projects_dir)
	if handle then
		while true do
			local name, type = vim.loop.fs_scandir_next(handle)
			if not name then break end
			if type == "directory" then
				table.insert(languages, name)
			end
		end
	end
	
	table.sort(languages)
	
	-- Add option to create new language directory
	table.insert(languages, 1, "📁 Create new language folder")
	
	vim.ui.select(languages, {
		prompt = "Select language/category:",
		format_item = function(item)
			if item == "📁 Create new language folder" then
				return item
			else
				return "📁 " .. item
			end
		end
	}, function(selected_lang)
		if not selected_lang then return end
		
		if selected_lang == "📁 Create new language folder" then
			-- Create new language directory
			vim.ui.input({
				prompt = "Language/category name: ",
				default = "",
			}, function(lang_name)
				if lang_name and lang_name ~= "" then
					lang_name = lang_name:gsub("[<>:\"/\\|?*]", "")
					local lang_path = M.projects_dir .. "\\" .. lang_name
					vim.fn.mkdir(lang_path, "p")
					M.create_project_in_language(lang_name)
				end
			end)
		else
			M.create_project_in_language(selected_lang)
		end
	end)
end

-- Create project in specific language directory
function M.create_project_in_language(language)
	vim.ui.input({
		prompt = "Project name (" .. language .. "): ",
		default = "",
	}, function(project_name)
		if project_name and project_name ~= "" then
			project_name = project_name:gsub("[<>:\"/\\|?*]", "")
			
			local project_path = M.projects_dir .. "\\" .. language .. "\\" .. project_name
			
			if vim.fn.isdirectory(project_path) == 1 then
				print("Project '" .. project_name .. "' already exists in " .. language .. "!")
				return
			end
			
			vim.fn.mkdir(project_path, "p")
			print("\nCreated project: " .. language .. "/" .. project_name)
			
			-- Close Alpha dashboard
			close_alpha()
			
			vim.cmd('cd ' .. project_path)
			vim.cmd('Neotree reveal')

			-- Create basic project structure
			vim.fn.mkdir('src', 'p')
			vim.fn.writefile({}, "README.md")
			
			print("Project '" .. language .. "/" .. project_name .. "' created successfully!")
		end
	end)
end

-- Enhanced telescope with hierarchical navigation
function M.telescope_projects()
	M.show_language_selector()
end

-- Show language selector first
function M.show_language_selector()
	local pickers = require "telescope.pickers"
	local finders = require "telescope.finders"
	local conf = require("telescope.config").values
	local actions = require "telescope.actions"
	local action_state = require "telescope.actions.state"

	-- Get language directories
	local languages = {}
	local handle = vim.loop.fs_scandir(M.projects_dir)
	if handle then
		while true do
			local name, type = vim.loop.fs_scandir_next(handle)
			if not name then break end
			if type == "directory" then
				-- Count projects in this language
				local lang_path = M.projects_dir .. "\\" .. name
				local project_count = 0
				local lang_handle = vim.loop.fs_scandir(lang_path)
				if lang_handle then
					while true do
						local proj_name, proj_type = vim.loop.fs_scandir_next(lang_handle)
						if not proj_name then break end
						if proj_type == "directory" then
							project_count = project_count + 1
						end
					end
				end
				
				table.insert(languages, {
					name = name,
					path = lang_path,
					project_count = project_count
				})
			end
		end
	end
	
	table.sort(languages, function(a, b) return a.name < b.name end)

	if #languages == 0 then
		print("No language directories found in " .. M.projects_dir)
		return
	end

	pickers.new({}, {
		prompt_title = "🌐 Select Language/Category",
		finder = finders.new_table {
			results = languages,
			entry_maker = function(entry)
				return {
					value = entry,
					display = "📁 " .. entry.name .. " (" .. entry.project_count .. " projects)",
					ordinal = entry.name,
				}
			end
		},
		sorter = conf.generic_sorter({}),
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				M.show_projects_in_language(selection.value.name, selection.value.path)
			end)
			return true
		end,
		previewer = false,
	}):find()
end

-- Show projects within selected language
function M.show_projects_in_language(language, language_path)
	local pickers = require "telescope.pickers"
	local finders = require "telescope.finders"
	local conf = require("telescope.config").values
	local actions = require "telescope.actions"
	local action_state = require "telescope.actions.state"

	-- Get projects in this language directory
	local projects = {}
	local handle = vim.loop.fs_scandir(language_path)
	if handle then
		while true do
			local name, type = vim.loop.fs_scandir_next(handle)
			if not name then break end
			if type == "directory" then
				table.insert(projects, {
					name = name,
					path = language_path .. "\\" .. name,
					language = language
				})
			end
		end
	end
	
	table.sort(projects, function(a, b) return a.name < b.name end)

	if #projects == 0 then
		print("No projects found in " .. language)
		return
	end

	pickers.new({}, {
		prompt_title = "📁 " .. language .. " Projects",
		finder = finders.new_table {
			results = projects,
			entry_maker = function(entry)
				return {
					value = entry,
					display = "📁 " .. entry.name,
					ordinal = entry.name,
				}
			end
		},
		sorter = conf.generic_sorter({}),
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				local project_path = selection.value.path
				
				-- Close Alpha dashboard
				close_alpha()
				
				vim.cmd('cd ' .. project_path)
				vim.cmd('Neotree reveal')
				print("Opened project: " .. selection.value.language .. "/" .. selection.value.name)
			end)
			
			-- Open in new tab
			map("i", "<C-t>", function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				local project_path = selection.value.path
				
				-- Close Alpha dashboard
				close_alpha()
				
				vim.cmd('tabnew')
				vim.cmd('cd ' .. project_path)
				vim.cmd('Neotree reveal')
				print("Opened project in new tab: " .. selection.value.language .. "/" .. selection.value.name)
			end)
			
			-- Go back to language selection
			map("i", "<C-b>", function()
				actions.close(prompt_bufnr)
				M.show_language_selector()
			end)
			
			return true
		end,
		previewer = false,
	}):find()
end

return M