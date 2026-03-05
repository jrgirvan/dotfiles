-- vim.pack.add is in lua/plugins/pack.lua
-- vim.pack.add({"https://github.com/zbirenbaum/copilot.lua"})

vim.api.nvim_create_autocmd("InsertEnter", {
	once = true,
	callback = function()
		require("copilot").setup({
			panel = { enabled = false },
			suggestion = {
				auto_trigger = true,
				keymap = {
					accept_word = "<C-l>",
					accept_line = "<C-j>",
				},
			},
		})
	end,
})

-- Keymaps
vim.keymap.set("i", "<C-a>", function()
	require("copilot.suggestion").accept()
end, { desc = "Copilot: Accept suggestion" })

vim.keymap.set("i", "<C-x>", function()
	require("copilot.suggestion").dismiss()
end, { desc = "Copilot: Dismiss suggestion" })

vim.keymap.set({ "n", "i" }, "<C-\\>", function()
	require("copilot.panel").open()
end, { desc = "Copilot: Show panel" })

-- User command (your init = function() block)
vim.api.nvim_create_user_command("Copilot", function()
	require("copilot.suggestion").toggle_auto_trigger()
end, {
	desc = "Toggle Copilot suggestions",
})
