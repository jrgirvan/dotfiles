local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
    spec = "jrgirvan.lazy",
    change_detection = { notify = false }
})
--[[
    use {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        requires = { { "nvim-lua/plenary.nvim" } }
    }
    use {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v1.x",
        requires = {
            -- LSP Support
            { "neovim/nvim-lspconfig" },
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },

            -- Autocompletion
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "saadparwaiz1/cmp_luasnip" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lua" },

            -- Snippets
            { "L3MON4D3/LuaSnip" },
            { "rafamadriz/friendly-snippets" },
        }
    }

    use "simrat39/rust-tools.nvim"
    use "folke/zen-mode.nvim"
    use "github/copilot.vim"

    use "ThePrimeagen/refactoring.nvim"
    use "ThePrimeagen/git-worktree.nvim"


    -- Colorscheme section
    use "gruvbox-community/gruvbox"
    use { "catppuccin/nvim", as = "catppuccin" }
    use "mortepau/codicons.nvim"
    use "romgrk/nvim-treesitter-context"

    use "mfussenegger/nvim-dap"
    use "rcarriga/nvim-dap-ui"
    use "nvim-telescope/telescope-dap.nvim"
    use "theHamsta/nvim-dap-virtual-text"
    use "mfussenegger/nvim-dap-python"
    use "leoluz/nvim-dap-go"

    use "nvim-lualine/lualine.nvim"

    use "gpanders/editorconfig.nvim"
 re("lazy").setup({
}, {})
--]]
