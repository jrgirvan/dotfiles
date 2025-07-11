return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local custom_catppuccin = require("catppuccin.utils.lualine")("mocha")

		-- Your custom color overrides
		local colors = {
			red = "#d46570",
			green = "#90e085",
			yellow = "#e8dfb8",
			peach = "#ed9a5f",
			teal = "#6cc7b8",
			sapphire = "#8a9ce8",
			mauve = "#e690cc",
		}

		-- Override specific mode colors by component
		custom_catppuccin.normal.a.bg = colors.sapphire -- Normal mode indicator
		custom_catppuccin.insert.a.bg = colors.green -- Insert mode indicator
		custom_catppuccin.insert.b.fg = colors.green -- Insert mode text
		custom_catppuccin.visual.a.bg = colors.mauve -- Visual mode indicator
		custom_catppuccin.visual.b.fg = colors.mauve -- Visual mode text
		custom_catppuccin.replace.a.bg = colors.red -- Replace mode indicator
		custom_catppuccin.replace.b.fg = colors.red -- Replace mode text
		custom_catppuccin.command.a.bg = colors.peach -- Command mode indicator
		custom_catppuccin.command.b.fg = colors.peach -- Command mode text

		-- Override diagnostic colors to match your theme
		if custom_catppuccin.normal and custom_catppuccin.normal.c then
			custom_catppuccin.normal.c.bg = custom_catppuccin.normal.c.bg or "#1e1e2e"
		end
		require("lualine").setup({
			options = {
				theme = custom_catppuccin, -- 'gruvbox', 'nord', 'solarized_dark', 'onedark', 'tokyonight'
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					"branch",
					{
						"diff",
						colored = true,
						diff_color = {
							added = { fg = colors.green },
							modified = { fg = colors.yellow },
							removed = { fg = colors.red },
						},
					},
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						symbols = {
							error = "󰅚 ", -- x000f015a
							warn = "󰀪 ", -- x000f002a
							info = "󰋽 ", -- x000f02fd
							hint = "󰌶 ", -- x000f0336
						},
						diagnostics_color = {
							error = { fg = colors.red },
							warn = { fg = colors.yellow },
							info = { fg = colors.sapphire },
							hint = { fg = colors.teal },
						},
					},
				},
				lualine_c = {
					{
						"filename",
						file_status = true, -- Displays file status (readonly status, modified status)
						newfile_status = false, -- Display new file status (new file means no write after created)
						path = 1, -- 0: Just the filename
						-- 1: Relative path
						-- 2: Absolute path
						-- 3: Absolute path, with tilde as the home directory

						shorting_target = 40, -- Shortens path to leave 40 spaces in the window
						-- for other components. (terrible name, any suggestions?)
						symbols = {
							modified = "[+]", -- Text to show when the file is modified.
							readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
							unnamed = "[No Name]", -- Text to show for unnamed buffers.
							newfile = "[New]", -- Text to show for new created file before first writting
						},
					},
				},
				--    lualine_x = {'encoding', 'fileformat', 'filetype'},
				--    lualine_y = {'progress'},
				--    lualine_z = {'location'}
			},
		})
	end,
}
