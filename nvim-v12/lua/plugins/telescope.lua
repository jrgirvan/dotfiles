-- vim.pack.add is in lua/plugins/init.lua
-- vim.pack.add({ "https://github.com/nvim-telescope/telescope.nvim" })

require("telescope").setup({})
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>pf", builtin.find_files, {})

vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>pw", function()
	builtin.grep_string({ search = vim.fn.expand("<cword>") })
end)
vim.keymap.set("n", "<leader>pW", function()
	builtin.grep_string({ search = vim.fn.expand("<cWORD>") })
end)

vim.keymap.set("n", "<leader>gc", builtin.git_branches, {})
