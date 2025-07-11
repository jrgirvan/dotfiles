return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			-- Customize or remove this keymap to your liking
			"ff",
			function()
				require("conform").format({ async = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	-- This will provide type hinting with LuaLS
	---@module "conform"
	---@type conform.setupOpts
	opts = {
		-- Define your formatters
		formatters_by_ft = {
			lua = { "stylua" },
			java = { "google-java-format" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
            nix = { "nixfmt" },
		},
		-- Set default options
		default_format_opts = {
			lsp_format = "fallback",
		},
		-- Set up format-on-save
		--format_on_save = { timeout_ms = 500 },
		-- Customize formatters
		--formatters = {
		--  shfmt = {
		--    prepend_args = { "-i", "2" },
		--  },
		--},
	},
	init = function()
		-- If you want the formatexpr, here is the place to set it
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}

--[[
return {
    'stevearc/conform.nvim',
    opts = {},
    config = function()
        local conform = require('conform')

        conform.setup({
            formatters_by_ft = {
                lua = { "stylua" },
                java = { "google-java-format" },
            },
        })

        vim.keymap.set('n', 'ff', function()
            conform.format({
                async = true,
                lsp_format = "fallback",
            })
        end, { desc = 'Format current buffer' })

    end,
}
--]]
