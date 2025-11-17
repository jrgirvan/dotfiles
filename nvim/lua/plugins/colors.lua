return {
	{
		"catppuccin/nvim",
		lazy = false,
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				custom_highlights = function(_)
					return {
						-- Override problematic colors
						--String = { fg = "#7adb70" }, -- blue instead of green
						--["@string"] = { fg = "#7adb70" },
						--GitSignsAdd = { fg = "#7adb70" },
						DiffAdd = { bg = "#1a2d42" },
						DiagnosticError = { fg = "#a0525a" },
						-- Custom line number highlights
						LineNr = { fg = "#6c7086" },
						CursorLineNr = { fg = "#f38ba8", bold = true },
					}
				end,
				color_overrides = {
					mocha = {
						red = "#d46570",
						green = "#90e085",
						yellow = "#e8dfb8",
						peach = "#ed9a5f",
						teal = "#6cc7b8",
						sapphire = "#8a9ce8",
						mauve = "#e690cc",
					},
				},
			})
			vim.cmd.colorscheme("catppuccin-mocha")
			-- Force cursor line number highlight after colorscheme/buffer loads
			vim.api.nvim_create_autocmd({ "ColorScheme", "BufEnter" }, {
				pattern = "*",
				callback = function()
					vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#f38ba8", bold = true })
				end,
			})
		end,
	},
	--[[
    {
        "folke/tokyonight.nvim",

        config = function()
            require('tokyonight').setup({
                style= "storm",
                transparent = true,
                terminal_colors = true,
                styles = {
                    comments = {italic = false},
                    keywords = {italic = false},
                    sidebars = "dark",
                    floats = "dark",
                }
            })
        end
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            vim.cmd("colorscheme rose-pine")
            require('rose-pine').setup({
                disable_background = true
            })
            ColorMyPencils()
        end
    },
    --]]
}
