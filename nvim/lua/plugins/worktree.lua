return {
	{
		"polarmutex/git-worktree.nvim",
		event = "VeryLazy",
		version = "^2",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("telescope").load_extension("git_worktree")
			-- Add hooks
			local Hooks = require("git-worktree.hooks")
			local config = require("git-worktree.config")
			local update_on_switch = Hooks.builtins.update_current_buffer_on_switch

			Hooks.register(Hooks.type.SWITCH, function(path, prev_path)
				vim.notify("Moved from " .. prev_path .. " to " .. path)
				update_on_switch(path, prev_path)
			end)

			Hooks.register(Hooks.type.DELETE, function()
				vim.cmd(config.update_on_change_command)
			end)

			-- Git Worktree mappings using telescope commands
			vim.keymap.set("n", "<leader>gm", "<cmd>Telescope git_worktree create_git_worktree<cr>", { desc = "Create worktree" })

			vim.keymap.set("n", "<leader>gw", "<cmd>Telescope git_worktree git_worktree<cr>", { desc = "Switch/Delete worktree" })
		end,
	},
}
