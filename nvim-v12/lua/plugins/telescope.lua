-- vim.pack.add is in lua/plugins/init.lua
-- vim.pack.add({ "https://github.com/nvim-telescope/telescope.nvim" })

require("telescope").setup({})
local builtin = require("telescope.builtin")
local jj_changed_files = require("config.jj_changed_files")
vim.keymap.set("n", "<leader>pf", builtin.find_files, {})

vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>pw", function()
	builtin.grep_string({ search = vim.fn.expand("<cword>") })
end)
vim.keymap.set("n", "<leader>pW", function()
	builtin.grep_string({ search = vim.fn.expand("<cWORD>") })
end)

vim.keymap.set("n", "<leader>gc", builtin.git_branches, {})
vim.keymap.set("n", "<leader>gs", jj_changed_files.pick_current_commit_files, { desc = "JJ changed files" })
