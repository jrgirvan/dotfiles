return {

        "nvim-telescope/telescope.nvim",
        dependencies = {
            "plenary"
        },

	config = function()
		require('telescope').setup({})
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
        --vim.keymap.set('n', '<C-p>', builtin.git_files, {})
        --vim.keymap.set('n', '<leader>ps', function()
        --	builtin.grep_string({ search = vim.fn.input("Grep > ") })
        --end)

        vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
        vim.keymap.set("n", "<leader>pw", function()
            builtin.grep_string { search = vim.fn.expand("<cword>") }
        end)
        vim.keymap.set("n", "<leader>pW", function()
            builtin.grep_string { search = vim.fn.expand("<cWORD>") }
        end)
        --vim.keymap.set("n", "<leader>pb", function()
        --    builtin.buffers()
        --end)

        require("telescope").load_extension("git_worktree")

        local worktree = require('telescope').extensions.git_worktree

        vim.keymap.set('n', '<leader>gc', builtin.git_branches, {})
        vim.keymap.set('n', '<leader>gw', worktree.git_worktrees, {})
        vim.keymap.set('n', '<leader>gm', worktree.create_git_worktree, {})
	end
}
