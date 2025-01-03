vim.cmd.packadd("packer.nvim")

return require("packer").startup(function(use)
    use "wbthomason/packer.nvim"

    use {
        "nvim-telescope/telescope.nvim", tag = "0.1.5",
        requires = { { "nvim-lua/plenary.nvim" } }
    }

    use {
        "rose-pine/neovim",
        as = "rose-pine",
        config = function()
            vim.cmd("colorscheme tokyonight")
        end
    }

    use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
    use "nvim-treesitter/playground"
    use "nvim-lua/plenary.nvim" -- don"t forget to add this one if you don"t have it yet!
    use {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        requires = { { "nvim-lua/plenary.nvim" } }
    }
    use "mbbill/undotree"
    use "tpope/vim-fugitive"
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

    -- Primeagen doesn"t create lodash
    use "ThePrimeagen/refactoring.nvim"
    use "ThePrimeagen/git-worktree.nvim"


    -- Colorscheme section
    use "gruvbox-community/gruvbox"
    use "folke/tokyonight.nvim"
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
    use "scheisa/relpointers.nvim"
    --use "huggingface/llm.nvim"
end)
