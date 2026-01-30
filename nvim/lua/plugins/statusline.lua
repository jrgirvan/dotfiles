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
		-- Cache for VCS info to reduce system calls
		local vcs_cache = {
			value = "",
			last_update = 0,
			cache_duration = 5000, -- 5 seconds in milliseconds
			updating = false,
		}

		-- Create custom highlight groups once at startup
		local function setup_highlight_groups()
			local lualine_b_hl = vim.api.nvim_get_hl(0, { name = "lualine_b_normal" })
			vim.api.nvim_set_hl(0, "lualine_b_bold", {
				fg = lualine_b_hl.fg,
				bg = lualine_b_hl.bg,
				bold = true,
			})
			vim.api.nvim_set_hl(0, "lualine_b_grey", {
				fg = "Gray",
				bg = lualine_b_hl.bg,
			})
		end

		local function update_vcs_info_async()
			if vcs_cache.updating then
				return
			end
			vcs_cache.updating = true

			-- Check jujutsu first
			vim.system(
				{
					"jj",
					"log",
					"-r",
					"@",
					"--no-graph",
					"--color",
					"never",
					"-T",
					'coalesce(bookmarks.join(", "), change_id) ++ "|" ++ change_id.shortest() ++ "|" ++ change_id.short()',
				},
				{ text = true },
				function(obj)
					vim.schedule(function()
						if obj.code == 0 and obj.stdout and obj.stdout ~= "" then
							local parts = vim.split(obj.stdout:gsub("%s+", ""), "|")
							if #parts >= 3 then
								local ref = parts[1]
								local shortest = parts[2]
								local short = parts[3]

                                -- if short is substring of ref hide ref
                                if short == ref:sub(1, #short) then
                                    ref = ""
                                end
                                -- limit ref display length to 10 characters, adding "..." if longer
                                local ref_display = ""
                                if #ref > 10 then
                                    ref_display = ref:sub(1, 7) .. "..."
                                else
                                    ref_display = ref
                                end

								-- Calculate padding to make total length = shortest + remaining = 4
								local shortest_len = #shortest
								local max_total_len = 5
								local remaining_len = math.max(0, max_total_len - shortest_len)
								local remaining = short:sub(shortest_len + 1, shortest_len + remaining_len)

								vcs_cache.value = "🥋"
									.. ref_display
									.. " %#lualine_b_bold#"
									.. shortest
									.. "%#lualine_b_grey#"
									.. remaining
									.. "%#lualine_b_normal#"
								vcs_cache.last_update = vim.loop.now()
								vcs_cache.updating = false
								return
							end
						end

						-- Fallback to git if jj failed
						vim.system({ "git", "branch", "--show-current" }, { text = true }, function(git_obj)
							vim.schedule(function()
								if git_obj.code == 0 and git_obj.stdout and git_obj.stdout ~= "" then
									vcs_cache.value = "󰊢 " .. git_obj.stdout:gsub("%s+", "")
								else
									vcs_cache.value = ""
								end
								vcs_cache.last_update = vim.loop.now()
								vcs_cache.updating = false
							end)
						end)
					end)
				end
			)
		end

		local function get_cached_vcs_info()
			local now = vim.loop.now()
			if now - vcs_cache.last_update > vcs_cache.cache_duration and not vcs_cache.updating then
				update_vcs_info_async()
			end
			return vcs_cache.value
		end

		-- Setup highlight groups and initialize VCS info on startup
		setup_highlight_groups()
		update_vcs_info_async()
		require("lualine").setup({
			options = {
				theme = custom_catppuccin, -- 'gruvbox', 'nord', 'solarized_dark', 'onedark', 'tokyonight'
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					{
						get_cached_vcs_info,
						icon = "",
					},
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
