-- My own custom project manager
local M = {}

local wsl = require('own.wsl')
M.projects_dir = wsl.is_wsl()
	and "/mnt/c/Users/Luca/Desktop/Projects"
	or "C:\\Users\\Luca\\Desktop\\Projects"

local function build_path(...)
	local path_sep = wsl.is_wsl() and "/" or "\\"
	local parts = {...}
	return table.concat(parts, path_sep)
end

local function close_alpha()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_get_option(buf, 'filetype') == 'alpha' then
			vim.api.nvim_buf_delete(buf, { force = true })
			break
		end
	end
end

function M.browse_projects()
	close_alpha()
	
	vim.cmd('cd ' .. M.projects_dir)
	vim.cmd('Neotree reveal')
	print("Browse projects in Neo-tree. Press 'P' on a project folder to set it as working directory.")
end

function M.new_project()
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
			vim.ui.input({
				prompt = "Language/category name: ",
				default = "",
			}, function(lang_name)
				if lang_name and lang_name ~= "" then
					lang_name = lang_name:gsub("[<>:\"/\\|?*]", "")
					local lang_path = build_path(M.projects_dir, lang_name)
					vim.fn.mkdir(lang_path, "p")
					M.create_project_in_language(lang_name)
				end
			end)
		else
			M.create_project_in_language(selected_lang)
		end
	end)
end

function M.create_project_in_language(language)
	vim.ui.input({
		prompt = "Project name (" .. language .. "): ",
		default = "",
	}, function(project_name)
		if project_name and project_name ~= "" then
			project_name = project_name:gsub("[<>:\"/\\|?*]", "")
			
			local project_path = build_path(M.projects_dir, language, project_name)
			
			if vim.fn.isdirectory(project_path) == 1 then
				print("Project '" .. project_name .. "' already exists in " .. language .. "!")
				return
			end
			
			vim.fn.mkdir(project_path, "p")
			print("\nCreated project: " .. language .. "/" .. project_name)
			
			close_alpha()
			
			vim.cmd('cd ' .. project_path)
			vim.cmd('Neotree reveal')

			vim.fn.mkdir(build_path(project_path, 'src'), 'p')
			vim.fn.writefile({}, build_path(project_path, "README.md"))
			
			print("Project '" .. language .. "/" .. project_name .. "' created successfully!")
		end
	end)
end

function M.telescope_projects()
	M.show_language_selector()
end

function M.show_language_selector()
	local pickers = require "telescope.pickers"
	local finders = require "telescope.finders"
	local conf = require("telescope.config").values
	local actions = require "telescope.actions"
	local action_state = require "telescope.actions.state"

	local languages = {}
	local handle = vim.loop.fs_scandir(M.projects_dir)
	if handle then
		while true do
			local name, type = vim.loop.fs_scandir_next(handle)
			if not name then break end
			if type == "directory" then
				local lang_path = build_path(M.projects_dir, name)
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
		finder = finders.new_table 
		{
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

function M.show_projects_in_language(language, language_path)
	local pickers = require "telescope.pickers"
	local finders = require "telescope.finders"
	local conf = require("telescope.config").values
	local actions = require "telescope.actions"
	local action_state = require "telescope.actions.state"

	local projects = {}
	local handle = vim.loop.fs_scandir(language_path)
	if handle then
		while true do
			local name, type = vim.loop.fs_scandir_next(handle)
			if not name then break end
			if type == "directory" then
				table.insert(projects, {
					name = name,
					path = build_path(language_path, name),
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
		finder = finders.new_table 
		{
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

function M.find_files()
	M.show_language_selector_for_find()
end

function M.show_language_selector_for_find()
	local pickers = require "telescope.pickers"
	local finders = require "telescope.finders"
	local conf = require("telescope.config").values
	local actions = require "telescope.actions"
	local action_state = require "telescope.actions.state"

	local languages = {}
	local handle = vim.loop.fs_scandir(M.projects_dir)
	if handle then
		while true do
			local name, type = vim.loop.fs_scandir_next(handle)
			if not name then break end
			if type == "directory" then
				local lang_path = build_path(M.projects_dir, name)
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
	
	-- Add option to search in entire projects directory
	table.insert(languages, 1, {
		name = "All Projects",
		path = M.projects_dir,
		project_count = 0
	})
	
	table.sort(languages, function(a, b) 
		if a.name == "All Projects" then return true end
		if b.name == "All Projects" then return false end
		return a.name < b.name 
	end)

	if #languages == 0 then
		print("No language directories found in " .. M.projects_dir)
		return
	end

	pickers.new({}, {
		prompt_title = "🔍 Select Directory to Search",
		finder = finders.new_table 
		{
			results = languages,
			entry_maker = function(entry)
				local display = entry.name == "All Projects" 
					and "📁 " .. entry.name .. " (search everywhere)"
					or "📁 " .. entry.name .. " (" .. entry.project_count .. " projects)"
				return {
					value = entry,
					display = display,
					ordinal = entry.name,
				}
			end
		},
		sorter = conf.generic_sorter({}),
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				if selection.value.name == "All Projects" then
					require('telescope.builtin').find_files({cwd = M.projects_dir})
				else
					M.show_projects_for_find(selection.value.name, selection.value.path)
				end
			end)
			return true
		end,
		previewer = false,
	}):find()
end

function M.show_projects_for_find(language, language_path)
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
					path = build_path(language_path, name),
					language = language
				})
			end
		end
	end
	
	-- Add option to search in entire language directory
	table.insert(projects, 1, {
		name = "All " .. language .. " Projects",
		path = language_path,
		language = language
	})
	
	table.sort(projects, function(a, b) 
		if a.name:match("^All ") then return true end
		if b.name:match("^All ") then return false end
		return a.name < b.name 
	end)

	if #projects == 0 then
		print("No projects found in " .. language)
		return
	end

	pickers.new({}, {
		prompt_title = "🔍 " .. language .. " - Select Project to Search",
		finder = finders.new_table 
		{
			results = projects,
			entry_maker = function(entry)
				local display = entry.name:match("^All ") 
					and "📁 " .. entry.name
					or "📁 " .. entry.name
				return {
					value = entry,
					display = display,
					ordinal = entry.name,
				}
			end
		},
		sorter = conf.generic_sorter({}),
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				require('telescope.builtin').find_files({cwd = selection.value.path})
			end)
			
			-- Go back to language selection
			map("i", "<C-b>", function()
				actions.close(prompt_bufnr)
				M.show_language_selector_for_find()
			end)
			
			return true
		end,
		previewer = false,
	}):find()
end

function M.open_config()
	local config_dir = wsl.is_wsl()
		and "/mnt/c/Users/Luca/AppData/Local/nvim"
		or "C:\\Users\\Luca\\AppData\\Local\\nvim"
	
	close_alpha()
	
	vim.cmd('cd ' .. config_dir)
	vim.cmd('Neotree reveal')
	print("Opened Neovim configuration directory")
end

return M
