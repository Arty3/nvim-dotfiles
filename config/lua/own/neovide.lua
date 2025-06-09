if vim.g.neovide then
	-- (0.0 = fully transparent, 1.0 = fully opaque)
	vim.g.neovide_opacity						= 0.8
	vim.g.neovide_window_blurred				= true

	vim.g.neovide_scale_factor					= 1.2

	vim.g.neovide_floating_shadow				= true
	vim.g.neovide_floating_z_height				= 10
	vim.g.neovide_light_angle_degrees			= 45
	vim.g.neovide_light_radius					= 5

	-- Disable cursor animation
	vim.g.neovide_cursor_animation_length		= 0
	vim.g.neovide_cursor_trail_size				= 0
	vim.g.neovide_cursor_animate_in_insert_mode	= false
	vim.g.neovide_cursor_animate_command_line	= false
end
