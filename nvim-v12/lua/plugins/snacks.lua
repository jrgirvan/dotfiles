-- vim.pack.add is in lua/plugins/pack.lua
-- vim.pack({"https://github.com/folke/snacks.nvim"})

require("snacks").setup({
	-- your configuration comes here
	-- or leave it empty to use the default settings
	-- refer to the configuration section below
	bigfile = { enabled = true },
	dashboard = { enabled = false },
	explorer = { enabled = false },
	git = { enabled = true },
	indent = { enabled = true },
	input = { enabled = true },
	notifier = { enabled = true },
	quickfile = { enabled = true },
	scope = { enabled = false },
	scroll = { enabled = false },
	statuscolumn = { enabled = false },
	words = { enabled = true },
	picker = {
		enables = true,
		actions = {
			opencode_send = function(...)
				return require("opencode").snacks_picker_send(...)
			end,
		},
		win = {
			input = {
				keys = {
					["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
				},
			},
		},
	},
})

-- Keymaps
vim.keymap.set("n", "<leader>sf", function()
	Snacks.scratch()
end, { desc = "Toggle Scratch Buffer" })
vim.keymap.set("n", "<leader>S", function()
	Snacks.scratch.select()
end, { desc = "Select Scratch Buffer" })
vim.keymap.set("n", "<leader>gl", function()
	Snacks.lazygit.log_file()
end, { desc = "Lazygit Log (cwd)" })
vim.keymap.set("n", "<leader>lg", function()
	Snacks.lazygit()
end, { desc = "Lazygit" })
vim.keymap.set("n", "<C-p>", function()
	Snacks.picker.pick("files")
end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>pb", function()
	Snacks.picker.buffers()
end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>ps", function()
	Snacks.picker.grep()
end, { desc = "Grep Files" })
