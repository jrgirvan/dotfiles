return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        { "fredrikaverpil/neotest-golang", version = "*" },
        { "nvim-neotest/neotest-python",   version = "*" },
        { "haydenmeade/neotest-jest",      version = "*" },
        { "Issafalcon/neotest-dotnet",     version = "*" },
    },
    config = function()
        local neotest_golang_opts = {} -- Specify custom configuration
        local neotest = require("neotest")
        neotest:setup({
            adapters = {
                require("neotest-golang")(neotest_golang_opts), -- Registration
                require("neotest-python")({
                    dap = { justMyCode = false },
                }),
                require("neotest-plenary"),
                require("neotest-vim-test")({
                    ignore_file_types = { "python", "vim", "lua" },
                }),
            },
        })
    end,
}
