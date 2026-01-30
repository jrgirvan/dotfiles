return {}

--[[return {
	{
		"olimorris/codecompanion.nvim", -- The KING of AI programming
		cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
		dependencies = {
			"j-hui/fidget.nvim", -- Display status
			-- { "echasnovski/mini.pick", config = true },
			-- { "ibhagwan/fzf-lua", config = true },
		},
		opts = {
			strategies = {
				chat = {
					adapter = {
						name = "copilot",
						model = "claude-sonnet-4.5",
					},
					roles = {
						user = "john.girvan",
					},
					keymaps = {
						send = {
							modes = {
								i = { "<C-CR>", "<C-s>" },
							},
						},
						completion = {
							modes = {
								i = "<C-x>",
							},
						},
                        close = {
                            modes = {
                                n = "rtyurtyu",
                                i = "<C-t>",
                            }
                        },
					},
					slash_commands = {
						["buffer"] = {
							keymaps = {
								modes = {
									i = "<C-b>",
								},
							},
						},
						["fetch"] = {
							keymaps = {
								modes = {
									i = "<C-f>",
								},
							},
						},
						["help"] = {
							opts = {
								max_lines = 1000,
							},
						},
						["image"] = {
							keymaps = {
								modes = {
									i = "<C-i>",
								},
							},
							opts = {
								dirs = { "~/Documents/Screenshots" },
							},
						},
					},
				},
				inline = {
					adapter = {
						name = "copilot",
						model = "claude-sonnet-4.5",
					},
				},
			},
			display = {
				action_palette = {
					provider = "default",
				},
				chat = {
					-- show_references = true,
					-- show_header_separator = false,
					-- show_settings = false,
					icons = {
						tool_success = "󰸞 ",
					},
					fold_context = true,
				},
			},
			opts = {
				log_level = "DEBUG",
			},
		},
		keys = {
			{
				"<leader>aa",
				"<cmd>CodeCompanionActions<CR>",
				desc = "Open the action palette",
				mode = { "n", "v" },
			},
			{
				"<leader>av",
				"<cmd>CodeCompanionChat Toggle<CR>",
				desc = "Toggle a chat buffer",
				mode = { "n", "v" },
			},
			{
				"<Localleader>a",
				"<cmd>CodeCompanionChat Add<CR>",
				desc = "Add code to a chat buffer",
				mode = { "v" },
			},
		},
		init = function()
			vim.cmd([cab cc CodeCompanion])
			require("plugins.custom.spinner"):init()
		end,
	},
}
--]]
