return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
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
        picker = { enabled = true },
        quickfile = { enabled = true },
        scope = { enabled = false },
        scroll = { enabled = false },
        statuscolumn = { enabled = false },
        words = { enabled = true },
    },
    keys = {
        { "<leader>sf",       function() Snacks.scratch() end,            desc = "Toggle Scratch Buffer" },
        { "<leader>S",        function() Snacks.scratch.select() end,     desc = "Select Scratch Buffer" },
        { "<leader>gl",       function() Snacks.lazygit.log_file() end,   desc = "Lazygit Log (cwd)" },
        { "<leader>lg",       function() Snacks.lazygit() end,            desc = "Lazygit" },
        { "<C-p>",            function() Snacks.picker.pick("files") end, desc = "Find Files" },
        --{ "<leader><leader>", function() Snacks.picker.recent() end,      desc = "Recent Files" },
        { "<leader>pb",       function() Snacks.picker.buffers() end,     desc = "Buffers" },
        { "<leader>ps",       function() Snacks.picker.grep() end,        desc = "Grep Files" },
        --{ "<C-n>",            function() Snacks.explorer() end,           desc = "Explorer" },
    }
}
