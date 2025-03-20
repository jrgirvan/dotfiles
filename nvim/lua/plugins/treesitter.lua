return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "vimdoc", "javascript", "typescript", "go", "lua", "rust", "python", "java" },
            sync_install = false,
            auto_install = true,
            indent = {
                enable = true,
            },
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = { "markdown" },
            },
        })

        local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
        parser_config.xdc = {
            install_info = {
                url = "~/work/odl/operational-data-layer/tree-sitter-xdc", -- local path or git repo
                files = { "src/parser.c" }, -- note that some parsers also require src/scanner.c or src/scanner.cc
                -- optional entries:
                generate_requires_npm = false, -- if stand-alone parser without npm dependencies
                requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
            },
            filetype = "xdc",                -- if filetype does not match the parser name
        }
    end
}
